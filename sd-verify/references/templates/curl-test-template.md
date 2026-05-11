# <feature-name> - curl 测试

> 测试地址：<base-url>
> 验证时间：YYYY-MM-DD

---

## 1. <接口名称> ⬜

apiKey: `<apiKey>`

```bash
curl -s -X POST '<full-url>' \
  -H '<required-header>' \
  -H 'Content-Type: application/json' \
  -d '{
    "apiKey": "<apiKey>",
    "params": {
      <参数>
    }
  }'
```

返回示例：
```json
{
  "success": true,
  "data": {}
}
```

**判断逻辑**：<业务判断说明>

---

## RPC 调用对照

| HTTP body | RPC DataApiRequest.paramsJson |
|-----------|------|
| `"params": {...}` | `"{\"key\": \"value\"}"` |

**规则**：RPC 的 `paramsJson` = HTTP body 的 `params` 对象 JSON.stringify 后的字符串。
