// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "lexxy"
import "@hotwired/turbo-rails"
import "controllers"
import "turbo_progress_bar"

// import "trix"

document.addEventListener("turbo:load", () => {
  const observerOptions = {
    root: null,
    rootMargin: "0px",
    threshold: 0.1
  };

  const observer = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);

  const elementsToReveal = document.querySelectorAll('.reveal-on-scroll');
  elementsToReveal.forEach(element => {
    observer.observe(element);
  });
});
