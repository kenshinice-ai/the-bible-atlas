# 《山海经 Atlas》幻想拼接总图生成状态

- 状态：`review_ready`
- 当前阶段：Phase 0 / Gate 0
- 证据层级：`local_candidate`
- 核心蓝图：[memoized-riding-giraffe.md](memoized-riding-giraffe.md)
- 美术方向：[FANTASY_COMPOSITE_MAP_ART_DIRECTION_2026-08-15.md](FANTASY_COMPOSITE_MAP_ART_DIRECTION_2026-08-15.md)
- prompt：[prompts/fantasy-composite-map-v1.txt](prompts/fantasy-composite-map-v1.txt)
- 当前结果：`blocked_missing_api_key`

## 1. 生成请求

- 工具：bundled ImageGen CLI `scripts/image_gen.py`
- model：`gpt-image-2`
- mode：`generate`
- size：`3840x2160`
- quality：`high`
- format：`png`
- intended output：`output/imagegen/shanhaijing-fantasy-composite-map-v1.png`
- prompt version：`fantasy-composite-map-v1`
- reference image usage：不作为 CLI 输入；只在文档中用于内部密度参考，避免复制未知权利图像

## 2. 当前环境

- CLI：`available`
- Python：`3.14.6`
- `OPENAI_API_KEY`：`missing`
- dry-run：`pass`，2026-08-15
- network/API generation：`not_run`
- output image：`not_generated`
- asset manifest：`not_generated`
- visual QA：`not_run`
- reviewer disposition：`blocked`

Dry-run 已确认请求使用 `/v1/images/generations`、`gpt-image-2`、`3840x2160`、`quality=high`、PNG，并计算目标路径为 `output/imagegen/shanhaijing-fantasy-composite-map-v1.png`。

Prompt：

- bytes：3314；
- SHA-256：`c73779d6d7c0c3ffc6fe186f46a22fd0ec6bc4bd6862239154447e31128a8cac`。

## 3. 可复现命令

```bash
python "/Users/llmacbookpro/.claude-code-router/profiles/default-codex/codex/skills/.system/imagegen/scripts/image_gen.py" generate \
  --prompt-file "docs/shanhaijing/prompts/fantasy-composite-map-v1.txt" \
  --model gpt-image-2 \
  --size 3840x2160 \
  --quality high \
  --output-format png \
  --out "output/imagegen/shanhaijing-fantasy-composite-map-v1.png"
```

## 4. 解除阻断

1. 在执行环境安全配置 `OPENAI_API_KEY`，不得写入仓库或文档；
2. 已完成的 dry-run 不替代真实调用；配置密钥后执行真实生成；
3. 使用 `view_image` 检查构图、畸形主体、重复生灵、意外文字、水印和现代符号；
4. 如需迭代，每次只修改一个明确问题，输出版本化文件名；
5. 选定最终图后复制到项目受控资产目录；
6. 生成 prompt/model/version/checksum/rights/disclosure manifest；
7. 更新 `HANDOFF.md`，不得在图像不存在时声称已生成。
