document.addEventListener('DOMContentLoaded', function() {
  const nameField = document.getElementById('organization_name');
  const subdomainField = document.getElementById('organization_subdomain');
  const passwordField = document.getElementById('password');
  const passwordConfirmationField = document.getElementById('password_confirmation');

  nameField.addEventListener('input', function() {
    let subdomain = nameField.value.toLowerCase().replace(/[^a-z0-9]/g, '');
    subdomainField.value = subdomain;
  });
  subdomainField.classList.add('text-info');

  function checkPasswordMatch() {
    if (passwordField.value === passwordConfirmationField.value) {
      passwordField.classList.remove('text-danger');
      passwordConfirmationField.classList.remove('text-danger');
      passwordField.classList.add('text-success');
      passwordConfirmationField.classList.add('text-success');
    } else {
      passwordField.classList.remove('text-success');
      passwordConfirmationField.classList.remove('text-success');
      passwordField.classList.add('text-danger');
      passwordConfirmationField.classList.add('text-danger');
    }
  }

  passwordField.addEventListener('input', checkPasswordMatch);
  passwordConfirmationField.addEventListener('input', checkPasswordMatch);
});