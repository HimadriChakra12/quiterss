/* ============================================================
 * LuaSettings implementation
 * Depends on: lua5.4 (or lua5.3 — API is identical for our usage)
 * Link with:  -llua5.4   (Linux)  or  -llua54  (Windows/MinGW)
 * ============================================================ */
#include "luasettings.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>
#include <QTextStream>
#include <QDebug>
#include <QByteArray>

extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

LuaSettings *LuaSettings::instance_ = nullptr;

// ---------------------------------------------------------------------------
// Construction / singleton
// ---------------------------------------------------------------------------

LuaSettings::LuaSettings(const QString &filePath)
    : filePath_(filePath)
{
    L_ = luaL_newstate();
    luaL_openlibs(L_);   // gives us tostring(), type(), pairs() etc. in the VM
    load();
}

LuaSettings::~LuaSettings()
{
    save();
    lua_close(L_);
}

void LuaSettings::createSettings(const QString &filePath)
{
    Q_ASSERT(!instance_);
    QString path = filePath;
    if (path.isEmpty()) {
        // Default: ~/.config/QuiteRSS/settings.lua  (Linux)
        //          %APPDATA%\QuiteRSS\settings.lua   (Windows)
        QString configDir = QStandardPaths::writableLocation(
            QStandardPaths::AppConfigLocation);
        QDir().mkpath(configDir);
        path = configDir + QDir::separator() + "settings.lua";
    }
    instance_ = new LuaSettings(path);
}

LuaSettings* LuaSettings::getSettings()
{
    Q_ASSERT(instance_);
    return instance_;
}

void LuaSettings::syncSettings()
{
    Q_ASSERT(instance_);
    instance_->save();
}

QString LuaSettings::fileName() const
{
    return filePath_;
}

// ---------------------------------------------------------------------------
// Load / Save
// ---------------------------------------------------------------------------

void LuaSettings::load()
{
    // Always start with an empty global 'settings' table so even if the
    // file doesn't exist or has errors we get a sane empty state.
    lua_newtable(L_);
    lua_setglobal(L_, "settings");

    QFile f(filePath_);
    if (!f.exists()) {
        qDebug() << "LuaSettings: no config file yet, starting fresh:" << filePath_;
        return;
    }

    // Execute the Lua file — it is expected to assign to the global 'settings'
    if (luaL_dofile(L_, filePath_.toUtf8().constData()) != LUA_OK) {
        qWarning() << "LuaSettings: error loading config:"
                   << lua_tostring(L_, -1);
        lua_pop(L_, 1);
        // Reset to empty table so we don't work with garbage
        lua_newtable(L_);
        lua_setglobal(L_, "settings");
    }
}

// Recursively write a Lua table as readable Lua source.
// indent = current nesting level (0 = top-level)
void LuaSettings::serializeTable(lua_State *L, int tableIndex,
                                  QTextStream &out, int indent) const
{
    const QString tab(indent * 2, ' ');
    const QString tab1((indent + 1) * 2, ' ');

    lua_pushnil(L);   // first key
    while (lua_next(L, tableIndex) != 0) {
        // key at -2, value at -1

        // Key — can be string or integer
        QString key;
        if (lua_type(L, -2) == LUA_TSTRING) {
            key = QString::fromUtf8(lua_tostring(L, -2));
            // Quote key if it's not a valid Lua identifier
            bool needsBracket = key.isEmpty()
                || (!key[0].isLetter() && key[0] != '_')
                || key.contains(QRegExp("[^\\w]"));
            if (needsBracket)
                out << tab1 << "[\"" << key.replace("\"","\\\"") << "\"] = ";
            else
                out << tab1 << key << " = ";
        } else {
            // integer key — use [n] = syntax
            out << tab1 << "[" << lua_tointeger(L, -2) << "] = ";
        }

        // Value
        int vtype = lua_type(L, -1);
        if (vtype == LUA_TTABLE) {
            out << "{\n";
            serializeTable(L, lua_gettop(L), out, indent + 1);
            out << tab1 << "},\n";
        } else if (vtype == LUA_TBOOLEAN) {
            out << (lua_toboolean(L, -1) ? "true" : "false") << ",\n";
        } else if (vtype == LUA_TNUMBER) {
            if (lua_isinteger(L, -1))
                out << lua_tointeger(L, -1) << ",\n";
            else
                out << lua_tonumber(L, -1) << ",\n";
        } else if (vtype == LUA_TSTRING) {
            // Escape backslashes and double-quotes, wrap in ""
            QString s = QString::fromUtf8(lua_tostring(L, -1));
            s.replace("\\", "\\\\");
            s.replace("\"", "\\\"");
            s.replace("\n", "\\n");
            out << "\"" << s << "\",\n";
        } else {
            // nil, function, userdata — skip
            lua_pop(L, 1);
            continue;
        }

        lua_pop(L, 1); // pop value, keep key for lua_next
    }
}

void LuaSettings::save() const
{
    QFile f(filePath_);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "LuaSettings: cannot write config:" << filePath_;
        return;
    }

    QTextStream out(&f);
    out.setCodec("UTF-8");
    out << "-- QuiteRSS configuration\n";
    out << "-- This file is auto-generated. You may edit it manually.\n";
    out << "-- Boolean: true/false   Numbers: plain   Strings: \"quoted\"\n\n";
    out << "settings = {\n";

    lua_getglobal(L_, "settings");
    if (lua_istable(L_, -1))
        serializeTable(L_, lua_gettop(L_), out, 0);
    lua_pop(L_, 1);

    out << "}\n";
    f.close();
}

// ---------------------------------------------------------------------------
// Group navigation
// ---------------------------------------------------------------------------

void LuaSettings::beginGroup(const QString &prefix)
{
    // Strip leading/trailing slashes to normalise "Settings/" -> "Settings"
    QString p = prefix;
    while (p.startsWith('/')) p.remove(0, 1);
    while (p.endsWith('/'))   p.chop(1);
    if (!p.isEmpty())
        groups_.push(p);
}

void LuaSettings::endGroup()
{
    if (!groups_.isEmpty())
        groups_.pop();
}

QString LuaSettings::group() const
{
    QStringList tmp(groups_.begin(), groups_.end()); return tmp.join(QLatin1Char('/'));
}

// ---------------------------------------------------------------------------
// Key resolution
// Merges the current group stack with a raw key that may itself contain "/"
// separators (e.g. "Settings/showSplash" called from root scope).
// Returns: groups = path components, leaf = final key name
// ---------------------------------------------------------------------------
void LuaSettings::resolveKey(const QString &rawKey,
                              QStringList &groups, QString &leaf) const
{
    // Build a full path: currentGroup / rawKey
    QStringList parts;
    for (const QString &g : groups_)
        parts << g.split('/', Qt::SkipEmptyParts);
    parts << rawKey.split('/', Qt::SkipEmptyParts);

    leaf   = parts.takeLast();
    groups = parts;
}

// Push the nested table for the given group path onto the Lua stack.
// Stack on return: ... [settings] [g1] [g2] ... [gN]   (groupPath.size()+1 values)
// Returns total slots pushed so the caller knows what to pop.
// If createIfMissing is true, missing intermediate tables are created.
int LuaSettings::pushGroupTable(bool createIfMissing)
{
    lua_getglobal(L_, "settings");   // push root table
    int pushed = 1;

    for (const QString &g : groups_) {
        const QByteArray key = g.toUtf8();
        lua_getfield(L_, -1, key.constData());
        pushed++;

        if (!lua_istable(L_, -1)) {
            lua_pop(L_, 1); // pop nil/wrong value
            pushed--;
            if (createIfMissing) {
                lua_newtable(L_);
                lua_pushvalue(L_, -1);              // dup table
                lua_setfield(L_, -3, key.constData()); // root[g] = table
                pushed++;
            } else {
                return pushed; // caller must check top is a table
            }
        }
    }
    return pushed;
}

// ---------------------------------------------------------------------------
// Read / Write
// ---------------------------------------------------------------------------

void LuaSettings::pushVariant(lua_State *L, const QVariant &v) const
{
    switch (v.type()) {
    case QVariant::Bool:
        lua_pushboolean(L, v.toBool() ? 1 : 0);
        break;
    case QVariant::Int:
    case QVariant::UInt:
    case QVariant::LongLong:
    case QVariant::ULongLong:
        lua_pushinteger(L, v.toLongLong());
        break;
    case QVariant::Double:
        lua_pushnumber(L, v.toDouble());
        break;
    case QVariant::ByteArray: {
        // Store binary data as a hex string prefixed with "base64:"
        // so we can round-trip QByteArray (geometry, state blobs etc.)
        QByteArray encoded = v.toByteArray().toBase64();
        QString s = "base64:" + QString::fromLatin1(encoded);
        lua_pushstring(L, s.toUtf8().constData());
        break;
    }
    case QVariant::StringList: {
        // Store as a Lua array table
        lua_newtable(L);
        QStringList sl = v.toStringList();
        for (int i = 0; i < sl.size(); i++) {
            lua_pushstring(L, sl[i].toUtf8().constData());
            lua_rawseti(L, -2, i + 1);   // Lua arrays are 1-indexed
        }
        break;
    }
    default:
        lua_pushstring(L, v.toString().toUtf8().constData());
        break;
    }
}

QVariant LuaSettings::toVariant(lua_State *L, int idx) const
{
    switch (lua_type(L, idx)) {
    case LUA_TBOOLEAN:
        return QVariant(lua_toboolean(L, idx) != 0);
    case LUA_TNUMBER:
        if (lua_isinteger(L, idx))
            return QVariant((int)lua_tointeger(L, idx));
        return QVariant((double)lua_tonumber(L, idx));
    case LUA_TSTRING: {
        QString s = QString::fromUtf8(lua_tostring(L, idx));
        // Decode base64-encoded QByteArray
        if (s.startsWith("base64:")) {
            QByteArray raw = QByteArray::fromBase64(
                s.mid(7).toLatin1());
            return QVariant(raw);
        }
        return QVariant(s);
    }
    case LUA_TTABLE: {
        // Assume it's a string array (for QStringList)
        QStringList sl;
        lua_pushnil(L);
        while (lua_next(L, idx < 0 ? idx - 1 : idx) != 0) {
            if (lua_type(L, -1) == LUA_TSTRING)
                sl << QString::fromUtf8(lua_tostring(L, -1));
            lua_pop(L, 1);
        }
        return QVariant(sl);
    }
    default:
        return QVariant();
    }
}

void LuaSettings::setValue(const QString &key, const QVariant &value)
{
    QStringList groups;
    QString leaf;
    resolveKey(key, groups, leaf);

    // Temporarily override group stack with resolved path
    QStack<QString> saved = groups_;
    groups_.clear();
    for (const QString &g : groups) groups_.push(g);

    int pushed = pushGroupTable(true);

    // Set the value in the innermost table
    pushVariant(L_, value);
    lua_setfield(L_, -2, leaf.toUtf8().constData());

    lua_pop(L_, pushed);
    groups_ = saved;
}

QVariant LuaSettings::value(const QString &key, const QVariant &defaultValue)
{
    QStringList groups;
    QString leaf;
    resolveKey(key, groups, leaf);

    QStack<QString> saved = groups_;
    groups_.clear();
    for (const QString &g : groups) groups_.push(g);

    int pushed = pushGroupTable(false);

    QVariant result = defaultValue;
    if (lua_istable(L_, -1)) {
        lua_getfield(L_, -1, leaf.toUtf8().constData());
        if (!lua_isnil(L_, -1))
            result = toVariant(L_, -1);
        lua_pop(L_, 1);
    }

    lua_pop(L_, pushed);
    groups_ = saved;
    return result;
}

bool LuaSettings::contains(const QString &key)
{
    QStringList groups;
    QString leaf;
    resolveKey(key, groups, leaf);

    QStack<QString> saved = groups_;
    groups_.clear();
    for (const QString &g : groups) groups_.push(g);

    int pushed = pushGroupTable(false);
    bool found = false;

    if (lua_istable(L_, -1)) {
        lua_getfield(L_, -1, leaf.toUtf8().constData());
        found = !lua_isnil(L_, -1);
        lua_pop(L_, 1);
    }

    lua_pop(L_, pushed);
    groups_ = saved;
    return found;
}

void LuaSettings::remove(const QString &key)
{
    QStringList groups;
    QString leaf;
    resolveKey(key, groups, leaf);

    QStack<QString> saved = groups_;
    groups_.clear();
    for (const QString &g : groups) groups_.push(g);

    int pushed = pushGroupTable(false);
    if (lua_istable(L_, -1)) {
        lua_pushnil(L_);
        lua_setfield(L_, -2, leaf.toUtf8().constData());
    }

    lua_pop(L_, pushed);
    groups_ = saved;
}
