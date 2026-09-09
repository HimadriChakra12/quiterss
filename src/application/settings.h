/* ============================================================
 * Settings — thin shim that delegates everything to LuaSettings.
 * All existing call sites (mainwindow.cpp etc.) include this header
 * and use the same API — nothing else needs to change.
 * ============================================================ */
#ifndef SETTINGS_H
#define SETTINGS_H

#include "luasettings.h"
#include <QVariant>
#include <QString>

class Settings
{
public:
  explicit Settings() {}
  ~Settings() {}

  static void createSettings(const QString &fileName = QString()) {
    LuaSettings::createSettings(fileName);
  }

  static LuaSettings* getSettings() {
    return LuaSettings::getSettings();
  }

  static void syncSettings() {
    LuaSettings::syncSettings();
  }

  QString fileName() {
    return LuaSettings::getSettings()->fileName();
  }

  void beginGroup(const QString &prefix) {
    LuaSettings::getSettings()->beginGroup(prefix);
  }

  void endGroup() {
    LuaSettings::getSettings()->endGroup();
  }

  void setValue(const QString &key, const QVariant &value = QVariant()) {
    LuaSettings::getSettings()->setValue(key, value);
  }

  QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) {
    return LuaSettings::getSettings()->value(key, defaultValue);
  }

  bool contains(const QString &key) {
    return LuaSettings::getSettings()->contains(key);
  }
};

#endif // SETTINGS_H
