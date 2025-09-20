# API 请求流程日志整理

## 接口请求概览

这个应用包含 **5 个主要 API 请求**，按顺序执行：

### 1. API-1: 面部分析 (FacePlusPlus)
- **功能**: 上传用户照片，获取面部特征数据
- **接口**: `https://api-cn.faceplusplus.com/facepp/v1/facialfeatures`
- **方法**: `[GlobalToolHandler requestWithImage:andCompletion:]`
- **触发**: 用户拍照后立即执行
- **数据处理**: 将返回的 JSON 存储到 `rawFaceString`

### 2. API-2: DeepSeek 初步总结
- **功能**: 基于面部数据生成基础分析结果
- **接口**: `https://api.deepseek.com/chat/completions`
- **方法**: `[GlobalToolHandler requestDeepSeekConclusion:]`
- **触发**: API-1 成功后立即执行
- **数据处理**: 更新 `conclusionModel`

### 3-5. API-3,4,5: DeepSeek 详细分析 (并发)
- **功能**: 3个并发请求，生成详细的妆容建议
- **接口**: `https://api.deepseek.com/chat/completions`
- **方法**: `[GlobalToolHandler requestAllWithSuccess:failure:]`
- **触发**: API-2 成功后延迟 2 秒执行
- **并发执行**:
  - **API-3 (RequestA)**: 五官特点分析 → `panelAFaceModel`
  - **API-4 (RequestB)**: 妆容风格建议 → `panelBDetailModel`
  - **API-5 (RequestC)**: 详细妆容方案 → `panelCRecommandModel`

## 日志标识系统

### 日志前缀含义
- 🔄 **开始请求** - 接口调用开始
- 📷 **图片处理** - 图片相关操作
- 📤 **请求参数** - 参数构造完成
- 🌐 **网络请求** - HTTP 请求发起
- 📥 **收到响应** - 服务器响应接收
- 📋 **数据提取** - 响应内容解析
- ✅ **成功完成** - 操作成功
- ❌ **请求失败** - 操作失败
- ⚠️ **警告信息** - 需要注意的情况
- 📝 **数据信息** - 数据相关信息
- 📄 **JSON数据** - 解析后的数据内容
- 🔍 **状态检查** - 结果状态验证
- ⏰ **延迟执行** - 定时任务
- 🔄 **重试操作** - 失败重试

### API 标识
- `[API-1]`: FacePlusPlus 面部分析
- `[API-2]`: DeepSeek 初步总结
- `[API-3]`: DeepSeek RequestA (五官特点)
- `[API-4]`: DeepSeek RequestB (妆容风格)
- `[API-5]`: DeepSeek RequestC (详细方案)
- `[API-3,4,5]`: 三个并发请求的统一标识

## 关键日志示例

### 成功流程日志
```
🔄 [API-1] 开始请求面部分析 - FacePlusPlus API
📷 [API-1] 图片处理完成 - 大小: 245.67KB, Base64长度: 335024
📤 [API-1] 请求参数准备完成 - API Key: FpYEOibTcWAdppV***
🌐 [API-1] 发起POST请求 - URL: https://api-cn.faceplusplus.com/facepp/v1/facialfeatures
📥 [API-1] 收到响应 - 耗时: 2.145 秒
✅ [API-1] 面部分析数据解析成功 - 数据长度: 12458 字符

🔄 [API-2] 开始请求DeepSeek初步总结
📤 [API-2] 请求参数构造完成 - 模型: deepseek-chat
🌐 [API-2] 发起POST请求 - URL: https://api.deepseek.com/chat/completions
📥 [API-2] 收到响应 - 耗时: 3.267 秒
✅ [API-2] JSON解析成功，模型数据更新完成

⏰ [API-3,4,5] 2秒后开始请求DeepSeek详细分析（3个并发请求）
🔄 [API-3,4,5] 开始并发请求DeepSeek详细分析 - 包含3个子请求
📥 [API-3,4,5] 所有并发请求完成 - 总耗时: 4.123 秒
✅ [API-3,4,5] 所有请求均成功，返回结果
```

### 失败排查日志
```
❌ [API-1] 请求失败 - 耗时: 10.000 秒
❌ [API-1] 错误详情: The request timed out.

❌ [API-2] JSON解析失败，原始内容: {"error": "Invalid request"}

❌ [API-3,4,5] 因RequestB失败而整体失败: Network connection lost
🔄 0.5秒后开始重试...
```

## 故障排查指南

### 1. API-1 失败排查
- 检查网络连接状态
- 验证 FacePlusPlus API Key 是否有效
- 确认图片大小是否超限
- 查看 `📷 [API-1]` 日志确认图片处理状态

### 2. API-2 失败排查  
- 检查 DeepSeek API Key 是否有效
- 确认 `rawFaceString` 数据是否正常
- 查看 JSON 解析错误信息
- 检查系统提示词格式

### 3. API-3,4,5 失败排查
- 查看 `🔍 [API-3,4,5]` 日志确定具体失败的子请求
- 检查并发请求的网络稳定性
- 确认各模型数据更新状态
- 查看重试机制是否正常工作

### 4. 常见错误码
- **网络超时**: 检查网络连接和服务器状态
- **JSON解析失败**: 检查 API 响应格式
- **API Key 无效**: 验证密钥配置
- **参数错误**: 检查请求参数格式

## 性能监控

### 关键指标
- **API-1 响应时间**: 通常 1-3 秒
- **API-2 响应时间**: 通常 2-5 秒  
- **API-3,4,5 并发时间**: 通常 3-8 秒
- **总流程时间**: 通常 8-15 秒

### 优化建议
1. 监控各 API 响应时间，异常时及时报警
2. 实现更智能的重试策略
3. 考虑增加请求缓存机制
4. 优化图片压缩算法减少传输时间
