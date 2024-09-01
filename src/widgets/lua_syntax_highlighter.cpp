/*
 * Copyright (C) 2014-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus Quest Editor is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus Quest Editor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "widgets/lua_syntax_highlighter.h"
#include "editor_style.h"
#include <QApplication>
#include <QVariant>

namespace SolarusEditor {

/**
 * @brief Creates a Lua syntax highlighter.
 * @param document The text document to highlight.
 */
LuaSyntaxHighlighter::LuaSyntaxHighlighter(QTextDocument* document) :
    QSyntaxHighlighter(document) {

  const EditorStyle* style = qobject_cast<const EditorStyle*>(qApp->style());
  if (style != nullptr) {
    connect(style, &EditorStyle::actual_mode_changed,
            this, &LuaSyntaxHighlighter::create_rules);
  }
  create_rules();
}

/**
 * @brief Creates or recreates highlighting rules.
 */
void LuaSyntaxHighlighter::create_rules() {

  const ModeInfo& mode_info = EditorStyle::get_mode_info();

  rules.clear();
  HighlightingRule rule;

  // The following awful regexp beginning can be used to match things that are
  // not in a string.
  // To do that, we check that the number of quotes and double-quotes is even.
  // (Keeping state information would probably be more readable.)
  QString not_in_a_single_line_string = "^[^\"']*(?:\"[^\"]*\"[^\"'']*|\'[^\']*\'[^\"']*)*";

  // Keywords.
  QTextCharFormat keyword_format;
  keyword_format.setForeground(mode_info.lua_keyword_color);
  keyword_format.setFontWeight(QFont::Bold);
  const QStringList keyword_patterns = {
    "\\band\\b",
    "\\bbreak\\b",
    "\\bdo\\b",
    "\\belse\\b",
    "\\belseif\\b",
    "\\bend\\b",
    "\\bfalse\\b",
    "\\bfor\\b",
    "\\bfunction\\b",
    "\\bif\\b",
    "\\bin\\b",
    "\\blocal\\b",
    "\\bnil\\b",
    "\\bnot\\b",
    "\\bor\\b",
    "\\brepeat\\b",
    "\\breturn\\b",
    "\\bthen\\b",
    "\\btrue\\b",
    "\\buntil\\b",
    "\\bwhile\\b"
  };

  for (const QString& pattern : keyword_patterns) {
    rule.pattern = QRegExp(pattern);
    rule.format = keyword_format;
    rules.append(rule);
  }

  // Strings.
  QTextCharFormat string_format;
  string_format.setForeground(mode_info.literal_string_color);
  rule.pattern = QRegExp("\"[^\"]*\"");
  rule.format = string_format;
  rules.append(rule);

  rule.pattern = QRegExp("'[^']*'");
  rule.format = string_format;
  rules.append(rule);

  // Comments.
  QTextCharFormat single_line_comment_format;
  single_line_comment_format.setForeground(mode_info.comment_color);
  // Avoid to highlight comments in strings,
  // and don't match --[[ or --]] markers.
  rule.pattern = QRegExp(
        not_in_a_single_line_string +
        R"((--([^\[\]]|\[[^\[]|\][^\]])[^\n]*$)$)"
  );
  rule.format = single_line_comment_format;
  rules.append(rule);

  comment_start_pattern = QRegExp("--\\[\\[");
  comment_end_pattern = QRegExp("--\\]\\]");
  QTextCharFormat multi_line_comment_format;
  multi_line_comment_format.setForeground(mode_info.comment_color);

  rehighlight();
}

/**
 * @brief Highlights part of the document.
 * @param text The text to highlight.
 */
void LuaSyntaxHighlighter::highlightBlock(const QString& text) {

  for (const HighlightingRule& rule : qAsConst(rules)) {
    QRegExp pattern(rule.pattern);
    int index = pattern.indexIn(text);
    if (pattern.captureCount() > 0) {
      index = pattern.pos(1);
    }
    while (index >= 0) {
      int length = pattern.matchedLength();
      if (pattern.captureCount() > 0) {
        const QStringList captures = pattern.capturedTexts();
        length = captures.first().size();
      }
      setFormat(index, length, rule.format);
      index = pattern.indexIn(text, index + length);
    }
  }
  setCurrentBlockState(0);

  int start_index = 0;
  if (previousBlockState() != 1) {
    start_index = comment_start_pattern.indexIn(text);
  }

  while (start_index >= 0) {
    int end_index = comment_end_pattern.indexIn(text, start_index);
    int comment_length;
    if (end_index == -1) {
      setCurrentBlockState(1);
      comment_length = text.length() - start_index;
    } else {
      comment_length = end_index - start_index
          + comment_end_pattern.matchedLength();
    }
    QTextCharFormat multi_line_comment_format;
    multi_line_comment_format.setForeground(EditorStyle::get_mode_info().comment_color);
    setFormat(start_index, comment_length, multi_line_comment_format);
    start_index = comment_start_pattern.indexIn(text, start_index + comment_length);
  }
}

}
