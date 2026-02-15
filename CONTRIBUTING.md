# Contributing to AISpeech

Thank you for your interest in contributing to AISpeech! This document provides guidelines for contributing to the project.

## Code of Conduct

Please be respectful and constructive in all interactions. We are committed to providing a welcoming and inclusive environment for everyone.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/saikittu332/AISpeech/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - iOS version and device information
   - Screenshots if applicable

### Suggesting Features

1. Check existing feature requests
2. Create a new issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Potential implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch from `main`
3. Follow the coding style guidelines
4. Write tests for new functionality
5. Update documentation as needed
6. Ensure all tests pass
7. Submit a pull request

## Development Setup

1. Install Xcode 13.0+
2. Clone the repository
3. Open `AISpeech.xcodeproj`
4. Build and run

## Coding Standards

### Swift Style Guide

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use SwiftLint for code formatting

### Architecture

- Follow MVVM pattern
- Keep ViewModels testable
- Use dependency injection
- Avoid tight coupling

### Testing

- Write unit tests for ViewModels
- Write unit tests for Services
- Add UI tests for critical flows
- Aim for >80% code coverage

### Documentation

- Document public APIs
- Update README for new features
- Add inline comments for complex code
- Update architectural diagrams if needed

## Commit Messages

Use clear and descriptive commit messages:

```
feat: Add offline speech recognition
fix: Resolve Core Data crash on background save
docs: Update API integration guide
test: Add unit tests for SpeechViewModel
refactor: Simplify authentication flow
```

Prefixes:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `test`: Tests
- `refactor`: Code refactoring
- `style`: Code style changes
- `perf`: Performance improvements

## Review Process

1. Submit pull request
2. Automated tests will run
3. Code review by maintainers
4. Address feedback
5. Merge after approval

## Questions?

Feel free to ask questions in:
- GitHub Issues
- Pull Request comments
- Email: dev@aispeech.com

Thank you for contributing! 🎉
