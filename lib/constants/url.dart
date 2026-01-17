const String ip = "10.18.47.30";
const String baseUrl = "http://$ip:8000/api";

const String userUrl = "$baseUrl/user";
const String registerUrl = "$baseUrl/register";
const String loginUrl = "$baseUrl/login";
const String logoutUrl = "$baseUrl/logout";

const String profileUrl = "$baseUrl/profile";

const String filterApartmentsUrl = "$baseUrl/filter";
const String getApartmentsUrl = "$baseUrl/getApartments";

const String favoritesUrl = "$baseUrl/favorites";
const String favoriteByIdUrl = "$baseUrl/favorites/{id}";

const String ownerApartmentsUrl = "$baseUrl/owner/apartments";
const String ownerApartmentByIdUrl = "$baseUrl/owner/apartments/{id}";

const String ownerApartmentImagesUrl = "$baseUrl/owner/apartmentsImages/{id}";

const String ownerReservationPendingUrl =
    "$baseUrl/owner/reservations/pending/{id}";
const String ownerReservationCancelUrl =
    "$baseUrl/owner/reservations/cancel/{id}";
const String ownerReservationEditUrl =
    "$baseUrl/owner/reservations/edit/{id}";
const String ownerApartmentReservationsUrl =
    "$baseUrl/owner/apartment/reservations/{id}";
const String ownerApartmentReservationsStatusUrl =
    "$baseUrl/owner/apartment/reservations/status/{id}";

const String tenantReservationsUrl =
    "$baseUrl/tenant/reservations";
const String tenantReservationCreateUrl =
    "$baseUrl/tenant/reservations/{id}";
const String tenantReservationEditUrl =
    "$baseUrl/tenant/reservations/edit/{id}";
const String tenantReservationCancelUrl =
    "$baseUrl/tenant/reservations/cancel";
const String tenantRateApartmentUrl =
    "$baseUrl/tenant/rate/{id}";

const String notificationsUrl = "$baseUrl/notifications";
const String notificationByIdUrl = "$baseUrl/notifications/{id}";

const String adminUsersSearchUrl =
    "$baseUrl/admin/users/search";
const String adminChangeUserRoleUrl =
    "$baseUrl/admin/users/role/{id}";
const String adminDeleteUserUrl =
    "$baseUrl/admin/users/delete/{id}";
const String adminVerifyUserUrl =
    "$baseUrl/admin/users/verify/{id}";
const String adminUnverifiedUsersUrl =
    "$baseUrl/admin/users/unverified";
