
// Base URL
const String ip ="10.65.11.61";
const String baseUrl = "http://$ip:8000/api";

// Auth
const String userUrl = "$baseUrl/user";
const String registerUrl = "$baseUrl/register";
const String loginUrl = "$baseUrl/login";
const String logoutUrl = "$baseUrl/logout";

// Profile
const String profileUrl = "$baseUrl/profile";

// Apartments (Owner)
const String apartmentsUrl = "$baseUrl/apartments";
const String apartmentByIdUrl = "$baseUrl/apartments/{id}";

// Apartments (Tenant)
const String filterApartmentsUrl = "$baseUrl/filter";

// Apartment Images (Owner)
const String apartmentImagesByIdUrl = "$baseUrl/apartmentsImages/{id}";

// Owner Reservations
const String ownerReservationPendingUrl = "$baseUrl/owner/reservations/pending/handle/{id}";
const String ownerReservationCancelUrl = "$baseUrl/owner/reservations/cancel/handle/{id}";
const String ownerReservationEditUrl = "$baseUrl/owner/reservations/edit/handle/{id}";
const String ownerApartmentReservationsUrl = "$baseUrl/owner/apartment/reservations/{id}";
const String ownerApartmentReservationsStatusUrl = "$baseUrl/owner/apartment/reservations/status/{id}";

// Tenant Reservations
const String tenantReservationsUrl = "$baseUrl/tenant/reservations";
const String tenantReservationCreateUrl = "$baseUrl/tenant/reservations/create";
const String tenantReservationEditUrl = "$baseUrl/tenant/reservations/edit/{id}";
const String tenantReservationCancelUrl = "$baseUrl/tenant/reservations/cancel/{id}";

// Favorites (Tenant)
const String favoritesUrl = "$baseUrl/favorites";
const String favoriteByIdUrl = "$baseUrl/favorites/{id}";

// Admin
const String adminUsersSearchUrl = "$baseUrl/admin/users/search";
const String adminUsersRoleUrl = "$baseUrl/admin/users/role/{id}";
const String adminUsersDeleteUrl = "$baseUrl/admin/users/delete/{id}";
const String adminUsersVerifyUrl = "$baseUrl/admin/users/verify/{id}";
const String adminUsersUnverifiedUrl = "$baseUrl/admin/users/unverified";
