# Security Policy（安全政策）

## Supported Versions（支持版本）

Use this section to tell people about which versions of your project are currently being supported with security updates. Security updates include patches for identified vulnerabilities, bug fixes related to security, and compliance adjustments.（本节用于说明项目当前哪些版本支持安全更新。安全更新包括已发现漏洞的补丁、与安全相关的漏洞修复以及合规性调整。）

|Version（版本）|Supported（支持状态）|End of Support (EoS)（支持结束时间）|
|---|---|---|
|5.1.x|:white_check_mark: (Active support: security updates + critical bug fixes)（主动支持：安全更新 + 关键漏洞修复）|TBD (To Be Determined)（待定）|
|5.0.x|:x: (No longer supported; upgrade to 5.1.x recommended)（不再支持；建议升级至5.1.x版本）|Already ended（已结束）|
|4.0.x|:white_check_mark: (Maintenance support: only critical security updates)（维护支持：仅关键安全更新）|TBD（待定）|
|< 4.0|:x: (No support; please migrate to a supported version)（不支持；请迁移至支持版本）|Already ended（已结束）|
Note: When a version reaches its End of Support (EoS), no further security updates will be provided. We strongly recommend upgrading to the latest supported version to ensure your deployment remains secure.（注意：当某个版本达到支持结束时间（EoS），将不再提供任何安全更新。我们强烈建议升级至最新支持版本，以确保您的部署环境安全。）

## Reporting a Vulnerability（漏洞报告）

We take security vulnerabilities seriously. If you discover a security vulnerability in our project, please follow the guidelines below to report it responsibly—this helps us address the issue promptly and protect our users.（我们高度重视安全漏洞问题。如果您在我们的项目中发现安全漏洞，请按照以下指南负责任地报告——这将帮助我们及时解决问题，保护我们的用户。）

### How to Report（报告方式）

Do NOT report security vulnerabilities through public GitHub Issues, Pull Requests, or Discussions, as this could expose the vulnerability to malicious actors before it is fixed.（请勿通过公开的GitHub Issues、Pull Requests或Discussions报告安全漏洞，因为这可能会在漏洞修复前将其暴露给恶意攻击者。）

Instead, please report vulnerabilities via:（请通过以下方式报告漏洞：）

- **GitHub Security Advisories（GitHub安全建议）**: Go to the project’s GitHub repository → navigate to the `Security` tab → click `Report a vulnerability` (under "Advisories") to submit a private report.（进入项目的GitHub仓库 → 导航至`Security`（安全）标签页 → 点击`Report a vulnerability`（报告漏洞，位于“Advisories”（建议）下方）提交私密报告。）
      

- **Direct Email（直接邮件）**: If you cannot use GitHub Security Advisories, send a detailed email to 2776085452@qq.com. Include "Security Vulnerability Report - [Project Name]" in the subject line.（如果您无法使用GitHub安全建议，请发送详细邮件至2776085452@qq.com。邮件主题请包含“Security Vulnerability Report - [项目名称]”（安全漏洞报告 - [项目名称]）。）

### Information to Include（需包含信息）

To help us quickly assess and fix the vulnerability, please include the following details in your report:（为帮助我们快速评估和修复漏洞，请在报告中包含以下详细信息：）

- A clear, descriptive title of the vulnerability (e.g., "Remote Code Execution via Unsanitized User Input in XYZ Feature").（清晰、描述性的漏洞标题（例如：“通过XYZ功能中未过滤的用户输入实现远程代码执行”）。）

- Detailed steps to reproduce the vulnerability (step-by-step instructions, code snippets, or test cases).（复现漏洞的详细步骤（分步说明、代码片段或测试用例）。）

- The affected version(s) of the project (if known; include exact version numbers).（受影响的项目版本（如有，请包含确切版本号）。）

- The impact of the vulnerability (e.g., data leakage, remote code execution, privilege escalation) and who/what it affects.（漏洞的影响（例如：数据泄露、远程代码执行、权限提升）以及影响范围。）

- Any potential mitigations or workarounds you have identified (if applicable).（您发现的任何潜在缓解措施或临时解决方案（如适用）。）

- Your contact information (optional, but recommended) so we can follow up with you for additional details.（您的联系方式（可选，但建议提供），以便我们跟进了解更多细节。）

### Response Timeline（响应时间）

We commit to responding to vulnerability reports in a timely manner. Here’s what you can expect:（我们承诺及时响应漏洞报告。您可以预期以下流程：）

- **Initial Acknowledgment（初步确认）**: We will acknowledge receipt of your report within 48 business hours.（我们将在48个工作小时内确认收到您的报告。）

- **Vulnerability Assessment（漏洞评估）**: We will review and assess the vulnerability within 5-7 business days to determine its severity (Critical, High, Medium, Low) and whether it is valid.（我们将在5-7个工作小时内审查并评估漏洞，确定其严重程度（严重、高、中、低）及有效性。）


- **Update Frequency（更新频率）**: We will provide you with regular updates on the progress of fixing the vulnerability (at least once per week) until the issue is resolved.（在问题解决前，我们将定期向您更新漏洞修复进度（每周至少一次）。）
     

- **Fix and Disclosure（修复与披露）**: Once a fix is developed and tested, we will coordinate with you to determine a disclosure timeline (typically 1-4 weeks after the fix is ready, to allow users to upgrade). We will credit you for the discovery (unless you request to remain anonymous).（一旦修复方案开发并测试完成，我们将与您协调确定披露时间（通常在修复完成后1-4周，以便用户升级）。我们将为您的发现署名（除非您要求匿名）。）
      

### Vulnerability Acceptance/Decline（漏洞接受/拒绝）

- **If Accepted（若接受）**: We will work to develop a patch for the vulnerability, release it in the next available update for supported versions, and notify users of the fix via release notes and GitHub Security Advisories.（我们将开发漏洞补丁，在支持版本的下一次更新中发布，并通过发布说明和GitHub安全建议通知用户。）
      

- **If Declined（若拒绝）**: We will provide a clear explanation of why the report was declined (e.g., the issue is not a security vulnerability, it is already fixed in a newer version, or it is outside the scope of the project). If you disagree with our assessment, you may provide additional evidence for us to re-review.（我们将明确说明拒绝报告的原因（例如：该问题并非安全漏洞、已在新版本中修复、或超出项目范围）。如果您不同意我们的评估，可以提供补充证据供我们重新审查。）
      

## Security Best Practices for Users（用户安全最佳实践）

To help keep your deployment secure, we recommend the following best practices:（为帮助您保持部署环境安全，我们建议遵循以下最佳实践：）

- Always use the latest supported version of the project to receive critical security updates.（始终使用项目的最新支持版本，以获取关键安全更新。）

- Follow the project’s documentation for secure configuration and deployment.（遵循项目文档进行安全配置和部署。）

- Regularly monitor GitHub Security Advisories for the project to stay informed about new vulnerabilities and fixes.（定期关注项目的GitHub安全建议，及时了解新漏洞和修复方案。）

- Report any suspicious activity or potential vulnerabilities you encounter (even if you are unsure).（如遇到任何可疑活动或潜在漏洞，请及时报告（即使您不确定）。）

## Responsible Disclosure Policy（负责任披露政策）

We ask that all reporters adhere to responsible disclosure practices: do not publicly disclose the vulnerability until we have had a reasonable amount of time to fix it and notify users. We will work with you to ensure a coordinated disclosure that protects all users.（我们要求所有报告者遵循负责任披露原则：在我们有足够时间修复漏洞并通知用户之前，请勿公开披露该漏洞。我们将与您合作，确保披露过程协调有序，保护所有用户。）

Last Updated: [Insert Date, e.g., March 11, 2026]（最后更新日期：[填写日期，例如：2026年3月11日]）
