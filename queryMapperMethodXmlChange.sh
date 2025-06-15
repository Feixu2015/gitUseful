#!/usr/bin/env bash
set -euo pipefail

# ---------- 配置区 ----------
# 要追踪的方法名（不含引号）
METHOD="pageByCondition"
# Mapper 文件相对路径
FILE="xxx-xxx-xxx/src/main/resources/META-INF/mybatis/sqlmap/XXX_XXX_CIDR_BLOCK.xml"
# 输出文档
OUTPUT="method_history.md"
# 可选：只追踪某个分支或时间段，这里以 master 分支为例
BRANCH="release/1.0.0"
SINCE=""   # e.g. "2021-01-01"
UNTIL=""   # e.g. "2025-06-15"
# ------------------------------

# 步骤 1：列出所有修改过该文件的提交 ID并直接处理
echo "正在扫描提交历史，请稍候……"
# 初始化输出文件
echo "# 方法 \`$METHOD\` 的变更历史" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "_生成时间：$(date '+%Y-%m-%d %H:%M:%S')_" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# 步骤 2：遍历每个提交，提取方法内容并追加到文档
commit_count=0

while read -r commit; do
  echo "## 提交 \`$commit\`" >> "$OUTPUT"

  # 添加提交信息
  echo "### 提交信息" >> "$OUTPUT"
  git show -s --format="* 提交人：\`%an <%ae>\`%n* 提交时间：\`%ad\`%n* 提交说明：%s%n* 详情：%b" "$commit" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  echo '```xml' >> "$OUTPUT"
  # 提取指定提交下的整个文件，并用 awk 抠出方法块
  git show "${commit}:${FILE}" \
    | awk -v method="$METHOD" 'BEGIN { in_block=0 } /<select.*id=/{ if ($0 ~ "id=\"" method "\"") in_block=1 } in_block { print } /<\/select>/{ if (in_block) exit }' \
    >> "$OUTPUT"
  echo '```' >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  ((commit_count++))
done < <(
  if [[ -n "$SINCE" || -n "$UNTIL" ]]; then
    git rev-list "$BRANCH" \
      $( [[ -n "$SINCE" ]] && echo '--since="$SINCE"') \
      $( [[ -n "$UNTIL" ]] && echo '--until="$UNTIL"') \
      -- "$FILE"
  else
    git rev-list "$BRANCH" -- "$FILE"
  fi
)

# 删除临时文件
echo "✅ 完成：方法历史已写入 \`$OUTPUT\`，共包含 $commit_count 次提交。"
