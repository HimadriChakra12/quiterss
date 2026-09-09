/* ============================================================
 * LuaSettings — drop-in replacement for QSettings backed by a Lua file.
 *
 * Config lives at:
 *   Linux:   ~/.config/QuiteRSS/settings.lua
 *   Windows: %APPDATA%\QuiteRSS\settings.lua
 *
 * The Lua file is a plain table assignment, human-editable:
 *
 *   settings = {
 *     Settings = {
 *       showSplashScreen   = true,
 *       feedsFontSize      = 12,
 *       styleApplication   = "greenStyle_",
 *     },
 *     Shortcuts = {
 *       ["feed/Add"] = "Ctrl+Plus",
 *     },
 *   }
 *
 * API is intentionally identical to the old Settings wrapper so no
 * call sites in mainwindow.cpp / mainapplication.cpp need to change.
 * ============================================================ */
#ifndef LUASETTINGS_H
#define LUASETTINGS_H

#include <QVariant>
#include <QString>
#include <QStringList>
#include <QStack>
#include <QTextStream>

// Forward-declare Lua state to avoid pulling lua.h into every TU
struct lua_State;

class LuaSettings
{
public:
  // ---- lifecycle ----------------------------------------------------------

  // Call once at startup (replaces Settings::createSettings)
  // Pass an explicit path or leave empty to use the default location.
  static void createSettings(const QString &filePath = QString());

  // Access the singleton
  static LuaSettings* getSettings();

  // Write the Lua file to disk (replaces QSettings::sync)
  static void syncSettings();

  // Path to the Lua file on disk
  QString fileName() const;

  // ---- group navigation ---------------------------------------------------
  // Mirrors QSettings group API — keys are looked up relative to the
  // current group stack, e.g. beginGroup("Settings") then value("showSplash")
  // resolves to settings["Settings"]["showSplash"] in Lua.
  void beginGroup(const QString &prefix);
  void endGroup();
  QString group() const;   // current group path, "/" separated

  // ---- read / write -------------------------------------------------------
  void     setValue(const QString &key, const QVariant &value);
  QVariant value   (const QString &key, const QVariant &defaultValue = QVariant());
  bool     contains(const QString &key);
  void     remove  (const QString &key);

  // ---- destructor ---------------------------------------------------------
  ~LuaSettings();

private:
  explicit LuaSettings(const QString &filePath);

  // Load settings.lua from disk into the Lua VM.
  // If the file doesn't exist an empty settings table is created.
  void load();

  // Serialise the in-memory Lua table back to a human-readable Lua file.
  void save() const;

  // Push the nested table for the current group onto the Lua stack.
  // Creates intermediate tables if they don't exist (for setValue).
  // Returns the number of stack slots pushed (caller must pop them).
  int  pushGroupTable(bool createIfMissing);

  // Resolve a key that may contain "/" separators into group + leaf,
  // merging with the current group stack.
  void resolveKey(const QString &rawKey, QStringList &groups, QString &leaf) const;

  // Recursively serialise a Lua table to a QTextStream (for save()).
  void serializeTable(lua_State *L, int tableIndex,
                      QTextStream &out, int indent) const;

  // Convert a QVariant to a Lua value pushed on the stack.
  void pushVariant(lua_State *L, const QVariant &v) const;

  // Convert the Lua value at stack index idx to a QVariant.
  QVariant toVariant(lua_State *L, int idx) const;

  lua_State      *L_;        // Lua VM — one per process lifetime
  QString         filePath_; // absolute path to settings.lua
  QStack<QString> groups_;   // current group navigation stack

  static LuaSettings *instance_;
};

#endif // LUASETTINGS_H
