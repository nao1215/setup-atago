# Security policy

## Supported versions
Only the latest release of setup-atago gets fixes, including security fixes. If you hit
an issue on an older version, please reproduce it on the latest release first.

## Reporting a vulnerability
Report security issues privately, not through public issues or pull requests.

- Email: n.chika156@gmail.com
- Or use the "Report a vulnerability" button on the repository's Security tab.

setup-atago downloads a prebuilt release binary onto a runner and puts it on `PATH`, so
reports about checksum verification, input handling (for example a version or
path input that injects shell or escapes the workspace), or secrets reaching
logs are especially useful. Please include enough detail to reproduce:

- The workflow snippet that uses the action (with inputs)
- The runner OS and architecture
- What you expected and what happened

## What to expect
setup-atago is maintained by one developer in spare time, so there is no guaranteed
response time. I will acknowledge the report, confirm the issue, and fix it in a
new release. You will be credited in the release notes unless you prefer to stay
anonymous.
