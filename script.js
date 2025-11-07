// Vecinity Landing Page - JavaScript

// ====================================
// WAIT FOR DOM TO BE READY
// ====================================
document.addEventListener('DOMContentLoaded', function() {

// ====================================
// MOBILE MENU FUNCTIONALITY
// ====================================
const mobileMenuButton = document.getElementById('mobile-menu-button');
const mobileMenu = document.getElementById('mobile-menu');

if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', (e) => {
        e.preventDefault();
        mobileMenu.classList.toggle('hidden');

        // Change icon
        const icon = mobileMenuButton.querySelector('i');
        if (mobileMenu.classList.contains('hidden')) {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        } else {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
        }
    });

    // Close mobile menu when clicking on a link
    const mobileMenuLinks = mobileMenu.querySelectorAll('a');
    mobileMenuLinks.forEach(link => {
        link.addEventListener('click', () => {
            mobileMenu.classList.add('hidden');
            const icon = mobileMenuButton.querySelector('i');
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        });
    });
}

// ====================================
// NAVBAR SCROLL EFFECT
// ====================================
const navbar = document.getElementById('navbar');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;

    if (currentScroll > 100) {
        navbar.classList.add('shadow-lg');
    } else {
        navbar.classList.remove('shadow-lg');
    }

    lastScroll = currentScroll;
});

// ====================================
// SMOOTH SCROLL FOR ANCHOR LINKS
// ====================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');

        if (targetId === '#') return;

        const targetElement = document.querySelector(targetId);
        if (targetElement) {
            const headerOffset = 80;
            const elementPosition = targetElement.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// ====================================
// FAQ ACCORDION FUNCTIONALITY
// ====================================
const faqButtons = document.querySelectorAll('.faq-button');

faqButtons.forEach(button => {
    button.addEventListener('click', () => {
        const content = button.nextElementSibling;
        const icon = button.querySelector('i');

        // Close all other FAQs
        faqButtons.forEach(otherButton => {
            if (otherButton !== button) {
                const otherContent = otherButton.nextElementSibling;
                const otherIcon = otherButton.querySelector('i');
                otherContent.classList.remove('active');
                otherContent.classList.add('hidden');
                otherButton.classList.remove('active');
                otherIcon.classList.remove('fa-chevron-up');
                otherIcon.classList.add('fa-chevron-down');
            }
        });

        // Toggle current FAQ
        content.classList.toggle('hidden');
        content.classList.toggle('active');
        button.classList.toggle('active');

        if (content.classList.contains('active')) {
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-up');
        } else {
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');
        }
    });
});

// ====================================
// CONTACT FORM HANDLING
// ====================================
const contactForm = document.getElementById('contact-form');
const formMessage = document.getElementById('form-message');

contactForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Get form data
    const formData = new FormData(contactForm);
    const data = Object.fromEntries(formData);

    // Validate form
    if (!validateForm(data)) {
        return;
    }

    // Show loading state
    const submitButton = contactForm.querySelector('button[type="submit"]');
    const originalButtonText = submitButton.innerHTML;
    submitButton.innerHTML = '<div class="spinner mr-2"></div> Enviando...';
    submitButton.disabled = true;

    try {
        // Simulate API call (replace with actual endpoint)
        await simulateFormSubmission(data);

        // Show success message
        showFormMessage('¡Gracias por tu interés! Nos pondremos en contacto contigo pronto.', 'success');

        // Reset form
        contactForm.reset();

        // Show toast notification
        showToast('Formulario enviado exitosamente', 'success');

    } catch (error) {
        // Show error message
        showFormMessage('Hubo un error al enviar el formulario. Por favor, intenta nuevamente.', 'error');
        showToast('Error al enviar el formulario', 'error');
    } finally {
        // Restore button state
        submitButton.innerHTML = originalButtonText;
        submitButton.disabled = false;
    }
});

// Form validation
function validateForm(data) {
    const requiredFields = ['name', 'email', 'phone', 'community_type', 'units_count'];

    for (const field of requiredFields) {
        if (!data[field] || data[field].trim() === '') {
            showFormMessage(`Por favor, completa el campo: ${getFieldLabel(field)}`, 'error');
            return false;
        }
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(data.email)) {
        showFormMessage('Por favor, ingresa un email válido', 'error');
        return false;
    }

    // Validate privacy checkbox
    if (!data.privacy) {
        showFormMessage('Debes aceptar la política de privacidad', 'error');
        return false;
    }

    return true;
}

// Get field label in Spanish
function getFieldLabel(field) {
    const labels = {
        'name': 'Nombre',
        'email': 'Email',
        'phone': 'Teléfono',
        'community_type': 'Tipo de comunidad',
        'units_count': 'Número de casas/departamentos'
    };
    return labels[field] || field;
}

// Show form message
function showFormMessage(message, type) {
    formMessage.textContent = message;
    formMessage.classList.remove('hidden', 'bg-green-100', 'bg-red-100', 'text-green-700', 'text-red-700');

    if (type === 'success') {
        formMessage.classList.add('bg-green-100', 'text-green-700');
    } else {
        formMessage.classList.add('bg-red-100', 'text-red-700');
    }

    formMessage.classList.remove('hidden');

    // Auto hide after 5 seconds
    setTimeout(() => {
        formMessage.classList.add('hidden');
    }, 5000);
}

// Simulate form submission (replace with actual API call)
function simulateFormSubmission(data) {
    return new Promise((resolve, reject) => {
        console.log('Form Data:', data);

        // Simulate API delay
        setTimeout(() => {
            // Simulate 90% success rate
            if (Math.random() > 0.1) {
                resolve({ success: true });
            } else {
                reject(new Error('Simulated error'));
            }
        }, 1500);
    });
}

// ====================================
// TOAST NOTIFICATIONS
// ====================================
function showToast(message, type = 'info') {
    // Remove existing toasts
    const existingToasts = document.querySelectorAll('.toast');
    existingToasts.forEach(toast => toast.remove());

    // Create toast element
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;

    // Add icon based on type
    let icon = 'fa-info-circle';
    if (type === 'success') icon = 'fa-check-circle';
    if (type === 'error') icon = 'fa-exclamation-circle';

    toast.innerHTML = `
        <div class="flex items-center">
            <i class="fas ${icon} mr-3 text-xl"></i>
            <span>${message}</span>
        </div>
    `;

    document.body.appendChild(toast);

    // Auto remove after 4 seconds
    setTimeout(() => {
        toast.style.animation = 'slideInRight 0.5s ease reverse';
        setTimeout(() => toast.remove(), 500);
    }, 4000);
}

// ====================================
// ANIMATED COUNTERS
// ====================================
function animateCounter(element, target, duration = 2000) {
    const start = 0;
    const increment = target / (duration / 16);
    let current = start;

    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            element.textContent = formatNumber(target);
            clearInterval(timer);
        } else {
            element.textContent = formatNumber(Math.floor(current));
        }
    }, 16);
}

function formatNumber(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M';
    } else if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'k';
    }
    return num.toString();
}

// Intersection Observer for counters
const observerOptions = {
    threshold: 0.5,
    rootMargin: '0px'
};

const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const counters = entry.target.querySelectorAll('.stat-number');
            counters.forEach(counter => {
                const target = parseInt(counter.textContent.replace(/[^0-9]/g, ''));
                if (!counter.classList.contains('animated')) {
                    animateCounter(counter, target);
                    counter.classList.add('animated');
                }
            });
            counterObserver.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe stats sections
document.addEventListener('DOMContentLoaded', () => {
    const statsSections = document.querySelectorAll('.grid > div');
    statsSections.forEach(section => {
        if (section.querySelector('.stat-number')) {
            counterObserver.observe(section.parentElement);
        }
    });
});

// ====================================
// SCROLL ANIMATIONS
// ====================================
const observeElements = document.querySelectorAll('section > div');

const fadeInObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-fadeInUp');
            fadeInObserver.unobserve(entry.target);
        }
    });
}, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
});

// ====================================
// FORM INPUT ANIMATIONS
// ====================================
const formInputs = document.querySelectorAll('input, textarea, select');

formInputs.forEach(input => {
    // Add focus effect
    input.addEventListener('focus', () => {
        const label = input.previousElementSibling;
        if (label && label.tagName === 'LABEL') {
            label.classList.add('text-primary');
        }
    });

    // Remove focus effect
    input.addEventListener('blur', () => {
        const label = input.previousElementSibling;
        if (label && label.tagName === 'LABEL') {
            label.classList.remove('text-primary');
        }
    });
});

// ====================================
// SCROLL TO TOP BUTTON
// ====================================
const scrollToTopButton = document.createElement('button');
scrollToTopButton.innerHTML = '<i class="fas fa-arrow-up"></i>';
scrollToTopButton.className = 'fixed bottom-8 right-8 w-12 h-12 bg-gradient-to-r from-primary to-secondary text-white rounded-full shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 z-50 hidden';
scrollToTopButton.setAttribute('aria-label', 'Volver arriba');
document.body.appendChild(scrollToTopButton);

window.addEventListener('scroll', () => {
    if (window.pageYOffset > 300) {
        scrollToTopButton.classList.remove('hidden');
    } else {
        scrollToTopButton.classList.add('hidden');
    }
});

scrollToTopButton.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});

// ====================================
// LAZY LOADING IMAGES
// ====================================
if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.classList.remove('lazy');
                imageObserver.unobserve(img);
            }
        });
    });

    const lazyImages = document.querySelectorAll('img.lazy');
    lazyImages.forEach(img => imageObserver.observe(img));
}

// ====================================
// TRACK CTA CLICKS
// ====================================
const ctaButtons = document.querySelectorAll('a[href="#contacto"]');

ctaButtons.forEach(button => {
    button.addEventListener('click', (e) => {
        // Track analytics here (Google Analytics, Mixpanel, etc.)
        console.log('CTA Clicked:', button.textContent.trim());

        // You can add your analytics tracking code here
        // Example: gtag('event', 'click', { 'event_category': 'CTA', 'event_label': button.textContent });
    });
});

// ====================================
// FORM FIELD TRACKING
// ====================================
const trackableFields = contactForm.querySelectorAll('input, select, textarea');

trackableFields.forEach(field => {
    field.addEventListener('blur', () => {
        if (field.value) {
            console.log(`Field completed: ${field.name}`);
            // Add analytics tracking here
        }
    });
});

// ====================================
// PRICING PLAN SELECTION
// ====================================
const pricingCards = document.querySelectorAll('.pricing-card');

pricingCards.forEach(card => {
    card.addEventListener('click', () => {
        const planName = card.querySelector('h3').textContent;
        console.log(`Plan selected: ${planName}`);
        // Add analytics tracking here
    });
});

// ====================================
// COPY TO CLIPBOARD (FOR SHARE LINKS)
// ====================================
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showToast('Enlace copiado al portapapeles', 'success');
    }).catch(err => {
        console.error('Error copying to clipboard:', err);
        showToast('Error al copiar el enlace', 'error');
    });
}

// ====================================
// KEYBOARD NAVIGATION IMPROVEMENTS
// ====================================
document.addEventListener('keydown', (e) => {
    // Close mobile menu with ESC key
    const mobileMenuEl = document.getElementById('mobile-menu');
    const mobileMenuBtn = document.getElementById('mobile-menu-button');
    if (e.key === 'Escape' && mobileMenuEl && !mobileMenuEl.classList.contains('hidden')) {
        mobileMenuEl.classList.add('hidden');
        if (mobileMenuBtn) {
            const icon = mobileMenuBtn.querySelector('i');
            if (icon) {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        }
    }

    // Close FAQ with ESC key
    if (e.key === 'Escape') {
        const faqButtons = document.querySelectorAll('.faq-button');
        faqButtons.forEach(button => {
            const content = button.nextElementSibling;
            const icon = button.querySelector('i');
            if (content && content.classList.contains('active')) {
                content.classList.remove('active');
                content.classList.add('hidden');
                button.classList.remove('active');
                if (icon) {
                    icon.classList.remove('fa-chevron-up');
                    icon.classList.add('fa-chevron-down');
                }
            }
        });
    }
});

// ====================================
// PERFORMANCE MONITORING
// ====================================
window.addEventListener('load', () => {
    // Log page load time
    const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
    console.log(`Page loaded in ${loadTime}ms`);

    // You can send this to your analytics service
});

// ====================================
// PREVENT FORM RESUBMISSION
// ====================================
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}

// ====================================
// END OF DOM CONTENT LOADED
// ====================================
    console.log('Vecinity Landing Page Loaded');

    // Example: Show welcome message (optional)
    // setTimeout(() => {
    //     showToast('¡Bienvenido a Vecinity!', 'info');
    // }, 1000);

}); // End of DOMContentLoaded

// ====================================
// EXTERNAL INTEGRATIONS PLACEHOLDER
// ====================================

// Google Analytics (add your tracking ID)
/*
window.dataLayer = window.dataLayer || [];
function gtag(){dataLayer.push(arguments);}
gtag('js', new Date());
gtag('config', 'GA_MEASUREMENT_ID');
*/

// Facebook Pixel (add your pixel ID)
/*
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', 'YOUR_PIXEL_ID');
fbq('track', 'PageView');
*/

// Hotjar (add your site ID)
/*
(function(h,o,t,j,a,r){
    h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
    h._hjSettings={hjid:YOUR_SITE_ID,hjsv:6};
    a=o.getElementsByTagName('head')[0];
    r=o.createElement('script');r.async=1;
    r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
    a.appendChild(r);
})(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
*/
