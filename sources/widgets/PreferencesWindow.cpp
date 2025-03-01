// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/PreferencesWindow.h>

#include <Preferences.h>
#include <Utils.h>

#include <QApplication>
#include <QBoxLayout>
#include <QformLayout>
#include <QComboBox>
#include <QScrollArea>
#include <QSpacerItem>
#include <QSignalBlocker>
#include <QTimer>
#include <QPushButton>
#include <QPainter>

#include <oclero/qlementine/widgets/Label.hpp>
#include <oclero/qlementine/widgets/Switch.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>
#include <oclero/qlementine/style/ThemeManager.hpp>

namespace solarus::launcher {
namespace i18n {
static QString windowTitle() {
  return QApplication::translate("SolarusLauncher", "%1 Preferences");
}
static QString appPreferencesTitle() {
  return QApplication::translate("SolarusLauncher", "Application");
}
static QString appLanguage() {
  return QApplication::translate("SolarusLauncher", "Language");
}
static QString appPropertiesPanelVisible() {
  return QApplication::translate("SolarusLauncher", "Show Quest Information Panel");
}
static QString appConsoleVisible() {
  return QApplication::translate("SolarusLauncher", "Show Console");
}
static QString appTheme() {
  return QApplication::translate("SolarusLauncher", "Theme");
}
static QString questPreferencesTitle() {
  return QApplication::translate("SolarusLauncher", "Quests");
}
static QString questEnableAudio() {
  return QApplication::translate("SolarusLauncher", "Audio Enabled");
}
static QString questForceSoftwareRendering() {
  return QApplication::translate("SolarusLauncher", "Force Software Rendering");
}
static QString questFullScreen() {
  return QApplication::translate("SolarusLauncher", "Full Screen");
}
static QString questSuspendWhenUnfocused() {
  return QApplication::translate("SolarusLauncher", "Suspend Quest when unfocused");
}
static QString reset() {
  return QApplication::translate("SolarusLauncher", "Reset");
}
static QString resetTooltip() {
  return QApplication::translate("SolarusLauncher", "Reset to factory defaults.");
}
} // namespace i18n

class BottomWidget : public QWidget {
  using QWidget::QWidget;

protected:
  void paintEvent(QPaintEvent*) override {
    const auto* style = qobject_cast<oclero::qlementine::QlementineStyle*>(this->style());
    const auto& bgColor = style ? style->theme().backgroundColorMain3 : palette().base();
    QPainter p(this);
    p.fillRect(rect(), bgColor);
  }
};

PreferencesWindow::PreferencesWindow(
  Preferences& preferences, oclero::qlementine::ThemeManager& themeManager, QWidget* parent)
  : QDialog(parent)
  , _preferences(preferences)
  , _themeManager(themeManager) {
  setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Preferred);
  setWindowTitle(i18n::windowTitle().arg(QApplication::applicationDisplayName()));
  setWindowModality(Qt::WindowModality::ApplicationModal);
  setWindowFlag(Qt::WindowType::WindowContextHelpButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowMaximizeButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowMinimizeButtonHint, false);
  setWindowFlag(Qt::WindowType::WindowFullscreenButtonHint, false);

  setupUi();
  ensurePolished();
  const auto sh = sizeHint() + QSize(0, 32);
  setFixedWidth(sh.width());
  setMaximumHeight(sh.height());
  setMinimumHeight(200);

  QTimer::singleShot(0, this, [this, sh]() {
    resize(sh);
  });
}

void PreferencesWindow::setupUi() {
  auto* rootLayout = new QVBoxLayout(this);
  rootLayout->setSpacing(0);
  rootLayout->setContentsMargins(0, 0, 0, 0);
  setLayout(rootLayout);

  auto* scrollArea = new QScrollArea(this);
  scrollArea->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
  rootLayout->addWidget(scrollArea);

  auto* scrollAreaContent = new QWidget(scrollArea);
  scrollAreaContent->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
  scrollArea->setWidgetResizable(true);
  scrollArea->setWidget(scrollAreaContent);

  auto* formLayout = new QFormLayout(scrollAreaContent);
  formLayout->setContentsMargins(32, 16, 32, 16);
  formLayout->setHorizontalSpacing(32);
  formLayout->setRowWrapPolicy(QFormLayout::RowWrapPolicy::DontWrapRows);
  scrollAreaContent->setLayout(formLayout);

  {
    auto* title = new oclero::qlementine::Label(this);
    title->setRole(oclero::qlementine::TextRole::H4);
    title->setText(i18n::appPreferencesTitle());
    formLayout->addRow(title);
  }
  {
    auto* comboBox = new QComboBox(this);
    comboBox->setMinimumWidth(100);
    for (const auto& lang : { "en_US", "fr_FR" }) {
      comboBox->addItem(lang, QString(lang));
    }
    formLayout->addRow(i18n::appLanguage(), comboBox);
  }
  {
    auto* comboBox = new QComboBox(this);
    comboBox->setMinimumWidth(100);

    const auto& themes = _themeManager.themes();
    const auto currentTheme = _preferences.appTheme();

    for (const auto& theme : themes) {
      const auto name = theme.meta.name;
      const auto icon = makeIcon(name == "Dark" ? Icons16::Misc_Moon : Icons16::Misc_Sun);
      comboBox->addItem(icon, name, QString(name));
    }

    const auto index = comboBox->findData(currentTheme);
    comboBox->setCurrentIndex(index);

    QObject::connect(comboBox, &QComboBox::currentIndexChanged, this, [this, comboBox](int index) {
      const auto theme = comboBox->itemData(index).toString();
      _preferences.setAppTheme(theme);
    });

    formLayout->addRow(i18n::appTheme(), comboBox);
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::appPropertiesPanelVisible(), switchButton);

    switchButton->setChecked(_preferences.appPropertiesPanelVisible());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setAppPropertiesPanelVisible(checked);
    });
    QObject::connect(&_preferences, &Preferences::appPropertiesPanelVisibleChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.appPropertiesPanelVisible();
      switchButton->setChecked(value);
    });
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::appConsoleVisible(), switchButton);

    switchButton->setChecked(_preferences.appConsoleVisible());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setAppConsoleVisible(checked);
    });
    QObject::connect(&_preferences, &Preferences::appConsoleVisibleChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.appConsoleVisible();
      switchButton->setChecked(value);
    });
  }
  {
    formLayout->addItem(new QSpacerItem(0, 16, QSizePolicy::Fixed, QSizePolicy::Fixed));
  }
  {
    auto* title = new oclero::qlementine::Label(this);
    title->setRole(oclero::qlementine::TextRole::H4);
    title->setText(i18n::questPreferencesTitle());
    formLayout->addRow(title);
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::questEnableAudio(), switchButton);

    switchButton->setChecked(_preferences.questEnableAudio());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setQuestEnableAudio(checked);
    });
    QObject::connect(&_preferences, &Preferences::questEnableAudioChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.questEnableAudio();
      switchButton->setChecked(value);
    });
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::questForceSoftwareRendering(), switchButton);

    switchButton->setChecked(_preferences.questForceSoftwareRendering());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setQuestForceSoftwareRendering(checked);
    });
    QObject::connect(&_preferences, &Preferences::questForceSoftwareRenderingChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.questForceSoftwareRendering();
      switchButton->setChecked(value);
    });
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::questFullScreen(), switchButton);

    switchButton->setChecked(_preferences.questFullScreen());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setQuestFullScreen(checked);
    });
    QObject::connect(&_preferences, &Preferences::questFullScreenChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.questFullScreen();
      switchButton->setChecked(value);
    });
  }
  {
    auto* switchButton = new oclero::qlementine::Switch(this);
    formLayout->addRow(i18n::questSuspendWhenUnfocused(), switchButton);

    switchButton->setChecked(_preferences.questSuspendWhenUnfocused());
    QObject::connect(switchButton, &QAbstractButton::clicked, this, [this](bool checked) {
      _preferences.setQuestSuspendWhenUnfocused(checked);
    });
    QObject::connect(&_preferences, &Preferences::questSuspendWhenUnfocusedChanged, this, [this, switchButton]() {
      QSignalBlocker _(switchButton);
      const auto value = _preferences.questSuspendWhenUnfocused();
      switchButton->setChecked(value);
    });
  }
  {
    formLayout->addItem(new QSpacerItem(0, 0, QSizePolicy::Fixed, QSizePolicy::Expanding));
  }
  {
    auto* container = new BottomWidget(this);
    container->setFocusPolicy(Qt::NoFocus);
    container->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
    auto* containerLayout = new QHBoxLayout(container);
    containerLayout->setContentsMargins(16, 12, 16, 12);
    container->setLayout(containerLayout);
    rootLayout->addWidget(container);

    auto* resetButton = new QPushButton(makeIcon(Icons16::Action_Reset), i18n::reset(), container);
    resetButton->setToolTip(i18n::resetTooltip());
    resetButton->setDefault(false);
    resetButton->setAutoDefault(false);
    resetButton->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    containerLayout->addWidget(resetButton);
    containerLayout->setAlignment(resetButton, Qt::AlignLeft);

    QObject::connect(resetButton, &QPushButton::clicked, this, [this]() {
      _preferences.resetToDefaults();
    });
  }
}
} // namespace solarus::launcher
