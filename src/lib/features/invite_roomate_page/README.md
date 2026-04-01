# Invite Roommate Feature

This feature enables inviting household members into the inventory app. It includes input validation for username/email and phone number, role selection, temporary success state, and navigation to a pending "view invites" flow.

---

## Data

### `data/constants.dart`
No feature-specific constants in this folder currently. The screen uses shared theme values in `src/config/theme.dart` and some inline colors (primary `#3A5A40`, secondary `#A3B18A`, background `#FBF7EF`).

---

## Presentation

### `presentation/routes.dart`
Go Router configuration for invite roommate route:
- `path: '/invite_roommate'`
- `builder`: wraps `InviteRoommateScreen` in `MultiBlocProvider`.
- Provider list currently includes `BlocProvider.value(value: sl<TodoCubit>())`.

> Setup requirements:
> - `TodoCubit` must be imported and registered with `GetIt` in `src/config/injection_dependencies.dart`.
> - `initializeDependencies()` should be called in `main()` before navigation.

### `presentation/pages/Invite_Roomates_Page.dart`
Main screen implementation:
- Stateful widget `InviteRoommateScreen` with `_InviteRoommateScreenState`.
- UI sections:
  - App logo + title `Invite Roommate`
  - Form card with input fields and role chips
  - Success view after invite is sent
- Form fields:
  - `_usernameController` (username/email)
  - `_phoneController` (phone number)
  - Role selection `_selectedRole`
- Validation:
  - `_isUsernameValid` uses regex `^[a-zA-Z0-9._-]{3,30}$`
  - `_isPhoneValid` requires 7–15 digits after non-digits removed
  - Error message when invalid and submitted
- Actions:
  - `_handleSendInvite()` sets `_inviteSent`, starts 1s timer then navigates to `'ViewInvites'` route with arguments
  - `handleViewInvitesPressed()` triggers one-time visual tap state and navigates to `'todos'` (placeholder)
- Lifecycle:
  - `dispose()` cancels timer + disposes controllers

### Behavior & UX
- Initial state shows the invite form.
- On successful submit, shows "Invite Sent!" plus a button "View Invites".
- View invitations path is in-flight / TODO in app router.

---


 
