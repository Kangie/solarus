// SPDX-License-Identifier: GPL-3.0-or-later
#include "Preferences.h"

#include <QGuiApplication>

namespace solarus::launcher {
namespace {
constexpr auto key_appLanguage{ "app/language" };
constexpr auto key_appPropertiesPanelVisible{ "app/propertiesPanelVisible" };
constexpr auto key_appConsoleVisible{ "app/appConsoleVisible" };
constexpr auto key_appTheme{ "app/theme" };
constexpr auto key_appQuestList{ "app/questList" };

constexpr auto key_windowX{ "window/x" };
constexpr auto key_windowY{ "window/y" };
constexpr auto key_windowWidth{ "window/width" };
constexpr auto key_windowHeight{ "window/height" };

constexpr auto key_questForceSoftwareRendering{ "quests/forceSoftwareRendering" };
constexpr auto key_questFullScreen{ "quests/fullScreen" };
constexpr auto key_questEnableAudio{ "quests/enableAudio" };
constexpr auto key_questSuspendWhenUnfocused{ "quests/suspendWhenUnFocused" };

constexpr auto default_appLanguage{ "en_US" };
constexpr auto default_appPropertiesPanelVisible{ false };
constexpr auto default_appConsoleVisible{ false };
constexpr auto default_appTheme{ "Dark" };

constexpr auto default_questForceSoftwareRendering{ false };
constexpr auto default_questFullScreen{ false };
constexpr auto default_questEnableAudio{ true };
constexpr auto default_questSuspendWhenUnfocused{ true };

QString applicationName() {
#if defined(Q_OS_WIN)
  return QGuiApplication::applicationDisplayName();
#else
  return QGuiApplication::applicationName().toLower().replace(' ', '-');
#endif
}

QString organizationName() {
#if defined(Q_OS_WIN)
  return QGuiApplication::organizationName();
#else
  return QGuiApplication::organizationName().toLower().replace(' ', '-');
#endif
}
} // namespace

Preferences::Preferences(QObject* parent)
  : QObject(parent)
  , _qSettings(QSettings::UserScope, organizationName(), applicationName()) {}

Preferences::~Preferences() {
  _qSettings.sync();
}

void Preferences::resetToDefaults() {
  setAppLanguage(default_appLanguage);
  setAppPropertiesPanelVisible(default_appPropertiesPanelVisible);
  setAppConsoleVisible(default_appConsoleVisible);
  setAppTheme(default_appTheme);

  setQuestEnableAudio(default_questEnableAudio);
  setQuestForceSoftwareRendering(default_questForceSoftwareRendering);
  setQuestFullScreen(default_questFullScreen);
  setQuestSuspendWhenUnfocused(default_questSuspendWhenUnfocused);
}

QString Preferences::appLanguage() const {
  return _qSettings.value(key_appLanguage, default_appLanguage).toString();
}

void Preferences::setAppLanguage(const QString& value) {
  if (value != appLanguage()) {
    _qSettings.setValue(key_appLanguage, value);
    emit appLanguageChanged();
  }
}

bool Preferences::appPropertiesPanelVisible() const {
  return _qSettings.value(key_appPropertiesPanelVisible, default_appPropertiesPanelVisible).toBool();
}

void Preferences::setAppPropertiesPanelVisible(bool value) {
  if (value != appPropertiesPanelVisible()) {
    _qSettings.setValue(key_appPropertiesPanelVisible, value);
    emit appPropertiesPanelVisibleChanged();
  }
}

bool Preferences::appConsoleVisible() const {
  return _qSettings.value(key_appConsoleVisible, default_appConsoleVisible).toBool();
}

void Preferences::setAppConsoleVisible(bool value) {
  if (value != appConsoleVisible()) {
    _qSettings.setValue(key_appConsoleVisible, value);
    emit appConsoleVisibleChanged();
  }
}

QString Preferences::appTheme() const {
  return _qSettings.value(key_appTheme, default_appTheme).toString();
}

void Preferences::setAppTheme(const QString& value) {
  if (value != appTheme()) {
    _qSettings.setValue(key_appTheme, value);
    emit appThemeChanged();
  }
}

QStringList Preferences::appQuestList() const {
  return _qSettings.value(key_appQuestList, QStringList{}).toStringList();
}

void Preferences::setQuestList(const QStringList& value) {
  if (value != appQuestList()) {
    _qSettings.setValue(key_appQuestList, value);
    emit appQuestListChanged();
  }
}

void Preferences::addQuestToList(const QString& value) {
  auto list = appQuestList();
  if (!list.contains(value)) {
    list.append(value);
    _qSettings.setValue(key_appQuestList, list);
    emit appQuestListChanged();
  }
}

int Preferences::windowX() const {
  return _qSettings.value(key_windowX, -1).toInt();
}

void Preferences::setWindowX(int value) {
  if (value != windowX()) {
    _qSettings.setValue(key_windowX, value);
    emit windowXChanged();
  }
}

int Preferences::windowY() const {
  return _qSettings.value(key_windowY, -1).toInt();
}

void Preferences::setWindowY(int value) {
  if (value != windowY()) {
    _qSettings.setValue(key_windowY, value);
    emit windowYChanged();
  }
}

int Preferences::windowWidth() const {
  return _qSettings.value(key_windowWidth, -1).toInt();
}

void Preferences::setWindowWidth(int value) {
  if (value != windowWidth()) {
    _qSettings.setValue(key_windowWidth, value);
    emit windowWidthChanged();
  }
}

int Preferences::windowHeight() const {
  return _qSettings.value(key_windowHeight, -1).toInt();
}

void Preferences::setWindowHeight(int value) {
  if (value != windowHeight()) {
    _qSettings.setValue(key_windowHeight, value);
    emit windowHeightChanged();
  }
}

bool Preferences::questEnableAudio() const {
  return _qSettings.value(key_questEnableAudio, default_questEnableAudio).toBool();
}

void Preferences::setQuestEnableAudio(bool value) {
  if (value != questEnableAudio()) {
    _qSettings.setValue(key_questEnableAudio, value);
    emit questEnableAudioChanged();
  }
}

bool Preferences::questForceSoftwareRendering() const {
  return _qSettings.value(key_questForceSoftwareRendering, default_questForceSoftwareRendering).toBool();
}

void Preferences::setQuestForceSoftwareRendering(bool value) {
  if (value != questForceSoftwareRendering()) {
    _qSettings.setValue(key_questForceSoftwareRendering, value);
    emit questForceSoftwareRenderingChanged();
  }
}

bool Preferences::questFullScreen() const {
  return _qSettings.value(key_questFullScreen, default_questFullScreen).toBool();
}

void Preferences::setQuestFullScreen(bool value) {
  if (value != questFullScreen()) {
    _qSettings.setValue(key_questFullScreen, value);
    emit questFullScreenChanged();
  }
}

bool Preferences::questSuspendWhenUnfocused() const {
  return _qSettings.value(key_questSuspendWhenUnfocused, default_questSuspendWhenUnfocused).toBool();
}

void Preferences::setQuestSuspendWhenUnfocused(bool value) {
  if (value != questSuspendWhenUnfocused()) {
    _qSettings.setValue(key_questSuspendWhenUnfocused, value);
    emit questSuspendWhenUnfocusedChanged();
  }
}
} // namespace solarus::launcher
