# GitHub Actions Workflows

This directory contains CI/CD workflows for the AISpeech iOS application.

## Available Workflows

### `ios-build-test.yml`

Automatically builds and tests the iOS app on every push and pull request.

**Purpose:** Enables Windows users (and all contributors) to validate their changes without needing local macOS access.

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual trigger via GitHub Actions UI (workflow_dispatch)

**What it does:**
1. Checks out the code
2. Configures Xcode
3. Builds the app for iOS Simulator
4. Runs unit tests
5. Archives test results
6. Provides build summary

**How to use:**
1. Make code changes on your Windows PC
2. Commit and push to GitHub
3. Go to the "Actions" tab in GitHub
4. Watch the build progress
5. Review results and logs

**Manual trigger:**
1. Go to GitHub repository
2. Click "Actions" tab
3. Select "iOS Build and Test" workflow
4. Click "Run workflow" button
5. Wait for results

**View results:**
- Green checkmark ✅ = Build successful
- Red X ❌ = Build failed (check logs)
- Yellow dot 🟡 = Build in progress

**Download artifacts:**
- Click on a completed workflow run
- Scroll to "Artifacts" section
- Download test results for detailed analysis

## For Windows Users

This workflow is especially useful for Windows developers who don't have access to macOS:

1. **Develop on Windows:** Use any code editor (VS Code, Sublime, etc.)
2. **Push to GitHub:** Commit and push your changes
3. **Automatic testing:** GitHub Actions builds and tests automatically
4. **Review results:** Check if build succeeds or fails
5. **Iterate:** Fix issues and push again

No Mac required! 🎉

## Cost

- **Public repositories:** Completely free
- **Private repositories:** 2,000 free minutes per month, then $0.008/minute

macOS runners use 10x multiplier, so 1 actual minute = 10 billed minutes.

## Tips

- Keep builds fast by caching dependencies
- Run tests on every push to catch issues early
- Use workflow_dispatch for on-demand testing
- Check logs when builds fail

## Learn More

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions for iOS](https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development)
- [Main Testing Guide](../../TESTING.md#testing-on-windows)
