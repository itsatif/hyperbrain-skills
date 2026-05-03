# AI-SDLC Skills Library Makefile
# Author: Atif Salafi <atif8486@gmail.com>

.PHONY: help install install-claude install-cursor install-copilot install-codex update verify uninstall clean

# Default target
.DEFAULT_GOAL := help

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

## help: Show this help message
help:
	@echo '${BLUE}AI-SDLC Skills Library - Command Reference${NC}'
	@echo ''
	@echo '${YELLOW}Usage:${NC} make [target]'
	@echo ''
	@echo '${YELLOW}Targets:${NC}'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
	@echo ''
	@echo '${YELLOW}Examples:${NC}'
	@echo '  make install-claude   # Install for Claude Code'
	@echo '  make install          # Install for Claude Code (default)'
	@echo '  make verify          # Verify installation'
	@echo '  make uninstall       # Remove installed skills'

## install: Install skills for Claude Code (default)
install:
	@echo '${BLUE}Installing AI-SDLC Skills for Claude Code...${NC}'
	@chmod +x install.sh
	@./install.sh --assistant claude

## install-claude: Install skills for Claude Code
install-claude:
	@echo '${BLUE}Installing AI-SDLC Skills for Claude Code...${NC}'
	@chmod +x install.sh
	@./install.sh --assistant claude

## install-cursor: Install skills for Cursor AI
install-cursor:
	@echo '${BLUE}Installing AI-SDLC Skills for Cursor AI...${NC}'
	@chmod +x install.sh
	@./install.sh --assistant cursor

## install-copilot: Install skills for GitHub Copilot
install-copilot:
	@echo '${BLUE}Installing AI-SDLC Skills for GitHub Copilot...${NC}'
	@chmod +x install.sh
	@./install.sh --assistant copilot

## install-codex: Install skills for OpenAI Codex
install-codex:
	@echo '${BLUE}Installing AI-SDLC Skills for OpenAI Codex...${NC}'
	@chmod +x install.sh
	@./install.sh --assistant codex

## update: Update installed skills to latest version
update:
	@echo '${BLUE}Updating AI-SDLC Skills...${NC}'
	@if [ -d "${HOME}/.claude/skills" ]; then \
		cd ${HOME}/.claude/skills && \
		git pull origin main; \
		echo '${GREEN}✓ Skills updated successfully${NC}'; \
	else \
		echo '${YELLOW}⚠ Skills not installed. Run "make install" first.${NC}'; \
	fi

## verify: Verify installation
verify:
	@echo '${BLUE}Verifying AI-SDLC Skills installation...${NC}'
	@if [ -d "${HOME}/.claude/skills" ]; then \
		echo '${GREEN}✓ Skills directory exists${NC}'; \
		echo ''; \
		echo 'Installed Skills:'; \
		cd ${HOME}/.claude/skills && \
		for skill in */SKILL.md; do \
			if [ -f "$$skill" ]; then \
				skill_name=$$(dirname $$skill); \
				echo "  $${GREEN}✓$${NC} $$skill_name"; \
			fi; \
		done; \
		echo ''; \
		echo '${GREEN}Installation verified!${NC}'; \
	else \
		echo '${YELLOW}⚠ Skills directory not found${NC}'; \
		echo 'Run "make install" to install skills.'; \
	fi

## status: Show installation status
status:
	@echo '${BLUE}AI-SDLC Skills Library Status${NC}'
	@echo ''
	@if [ -d "${HOME}/.claude/skills" ]; then \
		echo 'Installation Directory: $${HOME}/.claude/skills'; \
		echo ''; \
		echo 'Installed Skills:'; \
		cd ${HOME}/.claude/skills 2>/dev/null || true; \
		skills_count=$$(ls -1 */SKILL.md 2>/dev/null | wc -l | tr -d ' '); \
		if [ "$$skills_count" -gt 0 ]; then \
			for skill in */SKILL.md; do \
				if [ -f "$$skill" ]; then \
					skill_name=$$(dirname $$skill); \
					echo "  $${GREEN}✓$${NC} $$skill_name"; \
				fi; \
			done; \
			echo ''; \
			echo "$${GREEN}Total: $$skills_count skills installed$${NC}"; \
		else \
			echo '  $${YELLOW}No skills found$${NC}'; \
		fi; \
	else \
		echo '$${YELLOW}⚠ Skills not installed$${NC}'; \
		echo 'Run "make install" to install.'; \
	fi
	@echo ''

## uninstall: Remove installed skills
uninstall:
	@echo '${YELLOW}Uninstalling AI-SDLC Skills...${NC}'
	@if [ -d "${HOME}/.claude/skills" ]; then \
		read -p "Are you sure? [y/N] " -n 1 -r; \
		echo; \
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
			mv ${HOME}/.claude/skills ${HOME}/.claude/skills.backup.$$(date +%Y%m%d_%H%M%S); \
			echo '$${GREEN}✓ Skills uninstalled (backup created)${NC}'; \
		else \
			echo 'Uninstall cancelled.'; \
		fi; \
	else \
		echo '$${YELLOW}⚠ No skills installed$${NC}'; \
	fi

## clean: Remove backup files
clean:
	@echo '${BLUE}Cleaning up backup files...${NC}'
	@rm -rf ${HOME}/.claude/skills.backup.*
	@echo '${GREEN}✓ Cleanup complete${NC}'

## test: Run installation test
test:
	@echo '${BLUE}Testing installation...${NC}'
	@chmod +x install.sh
	@./install.sh --skip-backup --assistant claude
	@$(MAKE) verify

## docs: Open documentation
docs:
	@echo '${BLUE}Opening documentation...${NC}'
	@if command -v open >/dev/null 2>&1; then \
		open https://github.com/itsatif/ai-sdlc-skills; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open https://github.com/itsatif/ai-sdlc-skills; \
	else \
		echo "Open https://github.com/itsatif/ai-sdlc-skills in your browser"; \
	fi
