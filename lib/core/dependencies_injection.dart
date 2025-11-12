import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fox_mate_app/data/repositories/event_repository_impl.dart';
import 'package:fox_mate_app/data/repositories/navigation_repository_impl.dart';
import 'package:fox_mate_app/data/repositories/post_repository_impl.dart';
import 'package:fox_mate_app/domain/repositories/event_repository.dart';
import 'package:fox_mate_app/domain/repositories/navigation_repository.dart';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';
import 'package:fox_mate_app/domain/usecases/create_event_usecase.dart';
import 'package:fox_mate_app/domain/usecases/create_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/delete_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_events_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_events_paginated_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_posts_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_posts_paginated_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_user_posts_usecase.dart';
import 'package:fox_mate_app/domain/usecases/toggle_attendance_usecase.dart';
import 'package:fox_mate_app/domain/usecases/update_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/like_user_usecase.dart';
import 'package:fox_mate_app/providers/event_provider.dart';
import 'package:fox_mate_app/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/data/repositories/auth_repository_impl.dart';
import 'package:fox_mate_app/data/repositories/match_repository_impl.dart';
import 'package:fox_mate_app/data/repositories/notifications_repository_impl.dart';
import 'package:fox_mate_app/data/repositories/user_repository_impl.dart';
import 'package:fox_mate_app/domain/repositories/auth_repository.dart';
import 'package:fox_mate_app/domain/repositories/match_repository.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';
import 'package:fox_mate_app/domain/usecases/get_notifications.dart';
import 'package:fox_mate_app/domain/usecases/get_notifications_stream_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_unread_notifications_count_stream.dart';
import 'package:fox_mate_app/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:fox_mate_app/domain/usecases/forgot_password_usecase.dart';
import 'package:fox_mate_app/domain/usecases/sign_in_usecase.dart';
import 'package:fox_mate_app/domain/usecases/sign_out_usecase.dart';
import 'package:fox_mate_app/domain/usecases/sign_up_usecase.dart';
import 'package:fox_mate_app/domain/usecases/update_profile_usecase.dart';
import 'package:fox_mate_app/providers/auth_provider.dart' as auth_provider;
import 'package:fox_mate_app/providers/navigation_provider.dart';
import 'package:fox_mate_app/providers/notifications_provider.dart';
import 'package:fox_mate_app/providers/theme_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fox_mate_app/providers/user_provider.dart';

class DependenciesInjection {
  static List<SingleChildWidget> get providers {
    // Firebase
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // Repositories
    final AuthRepository authRepository = AuthRepositoryImpl(firebaseAuth);
    final UserRepository userRepository =
        UserRepositoryImpl(firebaseFirestore, firebaseStorage, firebaseAuth);
    final NavigationRepository navigationRepository =
        NavigationRepositoryImpl();
    final PostRepository postRepository = PostRepositoryImpl(
      firebaseFirestore,
      firebaseStorage,
    );
    final EventRepository eventRepository = EventRepositoryImpl(
      firebaseFirestore,
      firebaseStorage,
    );
    final MatchRepository matchRepository = MatchRepositoryImpl(firebaseFirestore);
    final NotificationsRepository notificationsRepository =
        NotificationsRepositoryImpl(firestore: firebaseFirestore);

    // UseCases - Autenticación
    final SignInUsecase signInUsecase = SignInUsecase(authRepository);
    final SignUpUsecase signUpUsecase = SignUpUsecase(
      authRepository,
      userRepository,
    );
    final SignOutUsecase signOutUsecase = SignOutUsecase(authRepository);
    final ForgotPasswordUseCase forgotPasswordUseCase =
        ForgotPasswordUseCase(authRepository);
    final UpdateProfileUseCase updateProfileUseCase =
        UpdateProfileUseCase(userRepository);

    // UseCases - Publicaciones
    final GetPostsUsecase getPostsUsecase = GetPostsUsecase(postRepository);
    final GetUserPostsUsecase getUserPostsUsecase =
        GetUserPostsUsecase(postRepository);
    final CreatePostUsecase createPostUsecase =
        CreatePostUsecase(postRepository);
    final DeletePostUsecase deletePostUsecase =
        DeletePostUsecase(postRepository);
    final UpdatePostUsecase updatePostUsecase =
        UpdatePostUsecase(postRepository);
    final GetPostsPaginatedUsecase getPostsPaginatedUsecase =
        GetPostsPaginatedUsecase(postRepository);

    // UseCases - Eventos
    final GetEventsUsecase getEventsUsecase =
        GetEventsUsecase(eventRepository);
    final CreateEventUsecase createEventUsecase =
        CreateEventUsecase(eventRepository);
    final ToggleAttendanceUsecase toggleAttendanceUsecase =
        ToggleAttendanceUsecase(eventRepository);
    final GetEventsPaginatedUsecase getEventsPaginatedUsecase =
        GetEventsPaginatedUsecase(eventRepository);

    // UseCases - Match / Likes
    final LikeUserUseCase likeUserUseCase = LikeUserUseCase(
      matchRepository,
      notificationsRepository,
      userRepository,
    );

    // UseCases - Notificaciones
    final GetNotificationsUseCase getNotificationsUseCase =
        GetNotificationsUseCase(notificationsRepository);
    final GetNotificationsStreamUseCase getNotificationsStreamUseCase =
        GetNotificationsStreamUseCase(notificationsRepository);
    final MarkNotificationsAsReadUseCase markNotificationsAsReadUseCase =
        MarkNotificationsAsReadUseCase(notificationsRepository);
    final GetUnreadNotificationsCountStreamUseCase
        getUnreadNotificationsCountStreamUseCase =
        GetUnreadNotificationsCountStreamUseCase(notificationsRepository);

    // Providers
    return [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),

      ChangeNotifierProvider(
        create: (context) => auth_provider.AuthProvider(
          signInUsecase,
          signUpUsecase,
          signOutUsecase,
          forgotPasswordUseCase,
          authRepository,
          userRepository,
        ),
      ),

      ChangeNotifierProvider(
        create: (context) => NavigationProvider(navigationRepository),
      ),

      ChangeNotifierProvider(
        create: (context) => PostProvider(
          getPostsUsecase,
          getUserPostsUsecase,
          createPostUsecase,
          deletePostUsecase,
          updatePostUsecase,
          getPostsPaginatedUsecase,
        ),
      ),

      ChangeNotifierProvider(
        create: (context) => EventProvider(
          getEventsUsecase,
          createEventUsecase,
          toggleAttendanceUsecase,
          getEventsPaginatedUsecase,
        ),
      ),

      ChangeNotifierProvider(
        create: (context) =>
            UserProvider(updateProfileUseCase, userRepository),
      ),

      Provider<LikeUserUseCase>.value(value: likeUserUseCase),

      ChangeNotifierProvider(
        create: (context) => NotificationsProvider(
          getNotificationsUseCase: getNotificationsUseCase,
          getNotificationsStreamUseCase: getNotificationsStreamUseCase,
          markNotificationsAsReadUseCase: markNotificationsAsReadUseCase,
          getUnreadNotificationsCountStreamUseCase:
              getUnreadNotificationsCountStreamUseCase,
        ),
      ),
    ];
  }
}
