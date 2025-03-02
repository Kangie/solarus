// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/BottomPanel.h>

#include <widgets/Console.h>
#include <Utils.h>
#include <Preferences.h>
#include <Controller.h>

#include <QVBoxLayout>
#include <QFrame>
#include <QLabel>
#include <QApplication>
#include <QPushButton>
#include <QPainter>

#include <oclero/qlementine/widgets/IconWidget.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>
#include <oclero/qlementine/utils/WidgetUtils.hpp>

namespace solarus::launcher {
namespace i18n {
static QString playingLabel() {
  return QApplication::translate("SolarusLauncher", "Playing:");
}
static QString closeConsole() {
  return QApplication::translate("SolarusLauncher", "Close console");
}
static QString clearConsole() {
  return QApplication::translate("SolarusLauncher", "Clear console");
}
static QString noQuestPlaying() {
  return QApplication::translate("SolarusLauncher", "No quest playing");
}
} // namespace i18n

class PlainTextEditBackground : public QWidget {
  using QWidget::QWidget;

protected:
  void paintEvent(QPaintEvent*) override {
    const auto* style = qobject_cast<oclero::qlementine::QlementineStyle*>(this->style());
    const auto& bgColor = style ? style->theme().backgroundColorWorkspace : palette().base();
    QPainter p(this);
    p.fillRect(rect(), bgColor);
  }
};

BottomPanel::BottomPanel(Controller* controller, QWidget* parent)
  : QWidget(parent)
  , _controller(controller) {
  setupUi();
}

void BottomPanel::setupUi() {
  auto* bottomWidgetLayout = new QVBoxLayout(this);
  setLayout(bottomWidgetLayout);
  bottomWidgetLayout->setSpacing(0);
  bottomWidgetLayout->setContentsMargins(0, 0, 0, 0);

  {
    auto* consoleToolBar = new QFrame(this);
    bottomWidgetLayout->addWidget(consoleToolBar);

    auto* consoleToolBarLayout = new QHBoxLayout(consoleToolBar);
    consoleToolBarLayout->setContentsMargins(12, 2, 4, 2);
    consoleToolBar->setLayout(consoleToolBarLayout);

    auto* iconWidget = new oclero::qlementine::IconWidget(consoleToolBar);
    consoleToolBarLayout->addWidget(iconWidget);

    auto* playingLayout = new QHBoxLayout();
    playingLayout->setContentsMargins(0, 0, 0, 0);
    playingLayout->setSpacing(4);
    consoleToolBarLayout->addLayout(playingLayout);

    auto* playingLabel = new QLabel(consoleToolBar);
    playingLabel->setText(QString("<b>%1</b>").arg(i18n::playingLabel()));
    playingLayout->addWidget(playingLabel);

    auto* consoleTitleLabel = new QLabel(consoleToolBar);
    consoleToolBarLayout->addWidget(consoleTitleLabel);
    playingLayout->addWidget(consoleTitleLabel);

    if (const auto* qlementine = qobject_cast<oclero::qlementine::QlementineStyle*>(style())) {
      const auto updatePalette = [qlementine, playingLabel, consoleTitleLabel, iconWidget]() {
        const auto palette = qlementine->paletteForTextRole(oclero::qlementine::TextRole::Caption);
        playingLabel->setPalette(palette);
        consoleTitleLabel->setPalette(palette);
        iconWidget->setPalette(palette);
      };
      updatePalette();
      QObject::connect(qlementine, &oclero::qlementine::QlementineStyle::themeChanged, this, [updatePalette]() {
        updatePalette();
      });
    }

    const auto updateQuestToolBar = [this, playingLabel, consoleTitleLabel, iconWidget]() {
      const auto path = _controller->runner()->questFilePath();
      const auto hasQuest = !path.isEmpty();
      consoleTitleLabel->setText(hasQuest ? path : i18n::noQuestPlaying());
      playingLabel->setVisible(hasQuest);
      iconWidget->setIcon(makeIcon(hasQuest ? Icons16::Software_CommandLine : Icons16::Misc_Info));
    };
    updateQuestToolBar();

    QObject::connect(_controller->runner(), &QuestRunner::questChanged, this, updateQuestToolBar);

    consoleToolBarLayout->addStretch();

    auto* clearConsoleButton = new QPushButton(consoleToolBar);
    clearConsoleButton->setToolTip(i18n::clearConsole());
    clearConsoleButton->setFocusPolicy(Qt::NoFocus);
    clearConsoleButton->setIconSize(QSize(12, 12));
    clearConsoleButton->setFixedSize(18, 18);
    clearConsoleButton->setFlat(true);
    clearConsoleButton->setIcon(makeIcon(Icons16::Action_Trash));
    consoleToolBarLayout->addWidget(clearConsoleButton);

    QObject::connect(clearConsoleButton, &QPushButton::clicked, this, [this]() {
      _ui.console->clear();
    });

    auto* closeButton = new QPushButton(consoleToolBar);
    closeButton->setToolTip(i18n::closeConsole());
    closeButton->setFocusPolicy(Qt::NoFocus);
    closeButton->setIconSize(QSize(12, 12));
    closeButton->setFixedSize(18, 18);
    closeButton->setFlat(true);
    closeButton->setIcon(makeIcon(Icons16::Action_Close));
    consoleToolBarLayout->addWidget(closeButton);

    QObject::connect(closeButton, &QPushButton::clicked, this, [this]() {
      _controller->preferences()->setAppConsoleVisible(false);
    });
  }
  {
    auto* line = oclero::qlementine::makeHorizontalLine(this);
    bottomWidgetLayout->addWidget(line);
  }
  {
    auto* consoleContainer = new PlainTextEditBackground(this);
    bottomWidgetLayout->addWidget(consoleContainer);

    consoleContainer->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    auto* consoleContainerLayout = new QVBoxLayout(consoleContainer);
    consoleContainerLayout->setContentsMargins(0, 0, 0, 0);
    consoleContainer->setLayout(consoleContainerLayout);
    consoleContainerLayout->setSpacing(0);

    _ui.console = new Console(consoleContainer);
    _ui.console->setMinimumHeight(100);
    _ui.console->set_quest_runner(_controller->runner());
    consoleContainerLayout->addWidget(_ui.console);
  }
}
} // namespace solarus::launcher
