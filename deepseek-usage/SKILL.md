---
name: deepseek-usage
description: 查询 DeepSeek API 账户余额。当用户提到"DeepSeek余额"、"DeepSeek用量"、"DeepSeek额度"、"deepseek balance"时触发。
---

# DeepSeek 用量查询

当用户询问 DeepSeek 余额或用量时，执行以下步骤：

1. 运行脚本获取余额数据：
   ```bash
   bash skills/deepseek-usage/scripts/balance.sh
   ```

2. 将脚本输出展示给用户

3. 如果余额较低（总余额 < 10 元），提醒用户及时充值

4. 如果请求失败，提示用户检查 API Key 是否有效
