enum AppRoutePath {
  splash(''),
  home('home'),
  sponsorship('be-sponsor'),
  speakers('speakers'),
  agenda('agenda'),
  privacyPolicy('privacy-policy'),
  termsConditions('terms-conditions');

  const AppRoutePath(this.pathName);

  final String pathName;
}
