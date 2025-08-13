/**
 * Shared Header JavaScript for PrivCheck
 * This file contains all header-related functionality and effects
 * To be included across all HTML pages for unified behavior
 */

// Header utility object - shared across all pages
window.HeaderUtils = {
    /**
     * Initialize all header effects and functionality
     */
    init: function() {
        this.initializeScrollEffects();
        this.initializeActiveNavigation();
        this.initializeAnimationEffects();
        this.addHeaderKeyboardNavigation();
    },

    /**
     * Header scroll effects - changes appearance on scroll
     */
    initializeScrollEffects: function() {
        const header = document.querySelector('.main-header');
        if (!header) return;

        window.addEventListener('scroll', function() {
            if (window.scrollY > 100) {
                header.style.backgroundColor = 'rgba(102, 126, 234, 0.95)';
                header.style.backdropFilter = 'blur(10px)';
                header.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.2)';
            } else {
                header.style.backgroundColor = '';
                header.style.backdropFilter = '';
                header.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.1)';
            }
        });
    },

    /**
     * Set active navigation link based on current page
     */
    initializeActiveNavigation: function() {
        const currentPage = window.location.pathname.split('/').pop() || 'index.html';
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentPage) {
                link.classList.add('active');
            }
        });
    },

    /**
     * Header entrance animation on page load
     */
    initializeAnimationEffects: function() {
        const header = document.querySelector('.main-header');
        if (!header) return;

        // Initial state - header slides down from top
        header.style.transform = 'translateY(-100%)';
        header.style.transition = 'transform 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
        
        // Animate in after a short delay
        setTimeout(() => {
            header.style.transform = 'translateY(0)';
        }, 100);

        // Add pulse effect to logo on hover
        const mainTitle = document.querySelector('.main-title');
        if (mainTitle) {
            mainTitle.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.05)';
                this.style.transition = 'transform 0.3s ease';
            });

            mainTitle.addEventListener('mouseleave', function() {
                this.style.transform = 'scale(1)';
            });
        }
    },

    /**
     * Add keyboard navigation support to header
     */
    addHeaderKeyboardNavigation: function() {
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach((link, index) => {
            link.addEventListener('keydown', function(e) {
                let targetIndex;
                
                switch(e.key) {
                    case 'ArrowRight':
                        e.preventDefault();
                        targetIndex = (index + 1) % navLinks.length;
                        navLinks[targetIndex].focus();
                        break;
                    case 'ArrowLeft':
                        e.preventDefault();
                        targetIndex = index === 0 ? navLinks.length - 1 : index - 1;
                        navLinks[targetIndex].focus();
                        break;
                    case 'Home':
                        e.preventDefault();
                        navLinks[0].focus();
                        break;
                    case 'End':
                        e.preventDefault();
                        navLinks[navLinks.length - 1].focus();
                        break;
                }
            });
        });
    },

    /**
     * Update active navigation programmatically
     * @param {string} pageName - Name of the page to set as active
     */
    setActivePage: function(pageName) {
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === pageName) {
                link.classList.add('active');
            }
        });
    },

    /**
     * Add smooth scroll behavior for in-page navigation
     */
    enableSmoothScroll: function() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    const headerHeight = document.querySelector('.main-header').offsetHeight;
                    const targetPosition = target.offsetTop - headerHeight - 20;
                    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });
    },

    /**
     * Toggle mobile navigation (for future mobile menu implementation)
     */
    toggleMobileNav: function() {
        const nav = document.querySelector('.main-nav');
        if (nav) {
            nav.classList.toggle('mobile-active');
        }
    }
};

// Auto-initialize header effects when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    HeaderUtils.init();
    HeaderUtils.enableSmoothScroll();
});

// Re-initialize on page visibility change (for SPA compatibility)
document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
        HeaderUtils.initializeActiveNavigation();
    }
});

// Export for global access
window.PrivCheckHeader = HeaderUtils;