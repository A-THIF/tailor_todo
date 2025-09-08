<<<<<<< HEAD
# Tailor Todo - Flutter Todo Reminder App


## Overview

Tailor Todo is a simple yet powerful Todo Reminder app built with Flutter and Supabase. The app allows users to:
- Sign in securely using **Google Authentication** via Supabase.
- Manage personal todo lists with real-time **CRUD** functionality.
- Receive **local notifications** for task reminders
=======
# Tailor Todo

A powerful Flutter todo app using Supabase for backend, Firebase for messaging, and local notifications for real-time task reminders.

>>>>>>> fb565c1ddc9af998fc6a3cd020c096d92530a4f6
---

## Features

- Google Sign-In powered by Supabase.
- Real-time synchronization of todos.
- Add, edit, and delete todos with deadlines.
- Local notifications implemented via [flutter_local_notifications].
- Responsive UI with modern design patterns.

---

## 📱 Screenshots

| Login Page | Sign In Page |
|------------|--------------|
| ![Login Page](https://github.com/user-attachments/assets/d3905989-bbf3-4bd9-9266-a918ee366210) | ![Sign In Page](https://github.com/user-attachments/assets/a1ea2254-4869-4e4e-bd9e-2e1870482dff) |

| Home Screen | Archived Screen |
|-------------|-----------------|
| ![Home Screen](https://github.com/user-attachments/assets/dfcf8936-dfd9-48ac-8969-47869fe29f03) | ![Archived Screen](https://github.com/user-attachments/assets/d1b4e82a-7024-499f-823e-6f299d6094f7) |

| Add Task Screen | Task Details Screen |
|-----------------|----------------------|
| ![Add Task Screen](https://github.com/user-attachments/assets/8949ddc3-fa3d-4dd6-93cc-f9ba1d4203df) | ![Task Details Screen](https://github.com/user-attachments/assets/66763360-40be-470d-92bb-80c3b887abdb) |

| Edit Task Details | Profile Screen |
|-------------------|----------------|
| ![Edit Task Details](https://github.com/user-attachments/assets/fc7cfe2a-eaa5-47e1-9c92-34bd860dced4) | ![Profile Screen](https://github.com/user-attachments/assets/0b58db22-8f2d-4201-a4e3-e6baad856261) |

| Edit Profile Screen | Delete Task Details |
|---------------------|----------------------|
| ![Edit Profile Screen](https://github.com/user-attachments/assets/09cb5706-4e89-4393-b1b9-5c800b293b4f) | ![Delete Task Details](https://github.com/user-attachments/assets/4c29258d-c0fb-47a5-b079-ef6bdbb4338e) |

| Delete Home Screen |
|---------------------|
| ![Delete Home Screen](https://github.com/user-attachments/assets/68334635-ca02-4802-8b27-fed466faaaac) |


---

#
## Push Notifications (Planned)

Push notifications will be implemented via Firebase Cloud Messaging (FCM) to send reminders exactly one hour before task deadlines using Supabase Edge Functions and Cron triggers.

Currently, local notifications remind users when tasks are due.

---

## Contribution

Contributions are welcome! Feel free to submit pull requests or open issues.

---

## License

This project is licensed under the [MIT License](LICENSE).

