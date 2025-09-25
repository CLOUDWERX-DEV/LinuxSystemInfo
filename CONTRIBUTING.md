# Contributing to Linux System Info

Thank you for your interest in contributing to Linux System Info! We welcome contributions from the community and are grateful for your help in making this project better.

## 🚀 Quick Start

### Prerequisites
- Linux system (any major distribution)
- Bash 4.0 or higher
- Git
- Basic knowledge of shell scripting

### Development Setup
```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/LinuxSystemInfo.git
cd LinuxSystemInfo

# Make scripts executable
chmod +x scripts/*.sh

# Test the scripts
./scripts/sysinfo.sh
./scripts/sysinfo-simple.sh
```

## 📋 Types of Contributions

We welcome several types of contributions:

### 🐛 Bug Reports
- Use the [issue tracker](https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/issues)
- Include your Linux distribution and version
- Provide terminal output and error messages
- Describe the expected vs actual behavior

### ✨ Feature Requests
- Check existing issues first to avoid duplicates
- Explain the use case and benefit
- Provide implementation suggestions if possible

### 💻 Code Contributions
- Bug fixes
- New features
- Performance improvements
- Documentation improvements
- Test coverage improvements

### 🌐 Platform Support
- Testing on new Linux distributions
- Compatibility fixes
- Distribution-specific enhancements

## 🔧 Development Guidelines

### Code Style
- Use consistent indentation (4 spaces)
- Follow existing naming conventions
- Add comments for complex logic
- Keep functions focused and modular
- Maintain compatibility with bash 4.0+

### Script Structure
```bash
#!/bin/bash
# Function description and purpose

function_name() {
    local variable_name="value"
    
    # Clear, descriptive comments
    command_here
    
    return 0
}
```

### Error Handling
- Always include error checking for critical operations
- Provide graceful fallbacks for missing dependencies
- Use timeouts for network operations
- Test error conditions thoroughly

### Performance
- Keep execution time reasonable (< 3 seconds for comprehensive mode)
- Cache expensive operations when possible
- Avoid unnecessary external command calls
- Test on older/slower hardware

## 📝 Pull Request Process

### 1. Preparation
```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Make your changes
# Test thoroughly on different distributions if possible
```

### 2. Testing Checklist
- [ ] Scripts run without errors on your system
- [ ] No breaking changes to existing functionality  
- [ ] Error handling works correctly
- [ ] Performance impact is minimal
- [ ] Documentation is updated if needed

### 3. Commit Guidelines
- Use clear, descriptive commit messages
- Start with a verb in imperative mood
- Keep the first line under 50 characters
- Add detailed description if needed

```bash
# Good commit messages
Add temperature monitoring for AMD CPUs
Fix memory percentage calculation on Alpine Linux
Update documentation for new installation method

# Poor commit messages  
Fix bug
Update stuff
Changes
```

### 4. Pull Request
- Fill out the pull request template
- Link related issues
- Describe what you changed and why
- Include screenshots for visual changes
- Request review from maintainers

## 🧪 Testing

### Manual Testing
Test your changes on:
- Different Linux distributions (if possible)
- Different terminal emulators
- Systems with/without optional dependencies
- Various hardware configurations

### Test Scenarios
- Systems with limited memory
- Systems with high disk usage
- Network connectivity issues
- Missing optional dependencies
- Different shell environments

### Automated Testing
We're working on automated testing infrastructure. In the meantime:
- Test edge cases manually
- Verify fallback behavior
- Check error conditions

## 📚 Documentation

### Code Documentation
- Add comments for complex logic
- Document function parameters and return values
- Explain non-obvious behavior
- Update inline help text

### README Updates
Update relevant sections when:
- Adding new features
- Changing installation procedures
- Modifying dependencies
- Adding distribution support

### Examples
Provide examples for:
- New configuration options
- Custom modifications
- Integration patterns

## 🎯 Feature Development

### Planning Phase
1. **Check existing issues** - Avoid duplicate work
2. **Discuss the feature** - Open an issue to discuss approach
3. **Design considerations** - Think about compatibility and performance
4. **Implementation plan** - Break down into smaller tasks

### Implementation Phase
1. **Start small** - Implement minimum viable version first
2. **Test early and often** - Test on multiple systems
3. **Document as you go** - Update docs alongside code
4. **Get feedback** - Share work-in-progress for early feedback

### Common Enhancement Areas

#### Hardware Detection
- New CPU architectures
- Additional GPU vendors (AMD, Intel)
- More hardware sensors
- USB device information

#### Software Detection
- Additional programming languages
- More development tools
- Container platforms (Podman, LXC)
- Database systems

#### Display Improvements
- New themes or color schemes
- Alternative layouts
- Responsive terminal sizing
- Export formats (JSON, XML)

#### System Integration
- Systemd integration
- Cron job templates
- Monitoring system plugins
- Shell integration improvements

## 🏷️ Issue Labels

We use labels to categorize issues:
- `bug` - Something isn't working
- `enhancement` - New feature or improvement
- `documentation` - Documentation related
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `question` - Question about usage
- `compatibility` - Distribution/hardware compatibility
- `performance` - Performance related

## 💬 Communication

### Getting Help
- 🐛 [Open an issue](https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/issues) for bugs
- 💬 [Start a discussion](https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/discussions) for questions
- 📧 Email [mail@cloudwerx.dev](mailto:mail@cloudwerx.dev) for sensitive matters

### Community Guidelines
- Be respectful and inclusive
- Help newcomers get started
- Share knowledge and resources
- Focus on constructive feedback
- Celebrate contributions from others

## 📜 License

By contributing to Linux System Info, you agree that your contributions will be licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

### What this means:
- Your code becomes part of the open-source project
- Others can use, modify, and distribute your contributions
- Your contributions are protected under the same license terms
- You retain copyright to your original work

## 🎖️ Recognition

Contributors are recognized in several ways:
- Listed in the project README
- Mentioned in release notes
- GitHub contributor statistics
- Special thanks for significant contributions

### Hall of Fame
Significant contributors may be featured in our project documentation with:
- Name and optional link
- Description of contribution
- Special recognition badge

## ❓ Questions?

Don't hesitate to ask questions! We're here to help:
- 📖 Check the [README](README.md) first
- 🔍 Search [existing issues](https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/issues)
- 💬 [Start a discussion](https://github.com/CLOUDWERX-DEV/LinuxSystemInfo/discussions)
- 📧 Email us at [mail@cloudwerx.dev](mailto:mail@cloudwerx.dev)

---

**Happy Contributing! 🚀**

*Made with ❤️ by the Linux System Info community*