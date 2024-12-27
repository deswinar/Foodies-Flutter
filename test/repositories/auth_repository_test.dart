import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodies/features/auth/data/auth_repository.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_firebase.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late AuthRepository authRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    authRepository = AuthRepository(mockFirebaseAuth);
  });

  group('AuthRepository', () {
    test('User registration should update Firestore', () async {
      // Mock FirebaseAuth.createUserWithEmailAndPassword
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      // Mock Firebase User
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockUser.updateDisplayName('Test User'))
          .thenAnswer((_) async => null);

      // Mock Firestore collection, document, and set
      final mockDocumentReference = MockDocumentReference();
      final mockCollectionReference = MockCollectionReference();
      when(mockFirestore.collection('users'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);

      // Instead of using any(), use an explicit map matching the structure.
      when(mockDocumentReference.set({
        'email': 'test@example.com',
        'uid': mockUser.uid,
        'displayName': 'Test User',
        'createdAt':
            anyNamed('createdAt'), // Use anyNamed for 'createdAt' field
        'photoURL': '',
      })).thenAnswer((_) async => Future.value());

      // Perform the test
      final user = await authRepository.signUp(
        'test@example.com',
        'password123',
        'Test User',
      );

      expect(user, mockUser);

      // Verify that Firestore methods were called
      verify(mockFirestore.collection('users')).called(1);
      verify(mockCollectionReference.doc(mockUser.uid)).called(1);

      // Verify the exact data that should have been passed to Firestore
      verify(mockDocumentReference.set({
        'email': 'test@example.com',
        'uid': mockUser.uid,
        'displayName': 'Test User',
        'createdAt': anyNamed('createdAt'),
        'photoURL': '',
      })).called(1);
    });

    test('Sign-Up should throw an exception on failure', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      expect(
        () async => await authRepository.signUp(
          'test@example.com',
          'password123',
          'Test User',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Sign-In should return a User on success', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      final user = await authRepository.signIn(
        'test@example.com',
        'password123',
      );

      expect(user, mockUser);
    });

    test('Sign-In should throw an exception on failure', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        () async => await authRepository.signIn(
          'test@example.com',
          'wrongpassword',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Google Sign-In should return a User on success', () async {
      // Mock Google Sign-In Account
      final mockGoogleSignInAccount = MockGoogleSignInAccount();
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      // Mock Authentication Result
      final mockAuthentication = MockGoogleSignInAuthentication();
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockAuthentication);

      // Mock Firebase Credentials
      when(mockAuthentication.accessToken).thenReturn('mockAccessToken');
      when(mockAuthentication.idToken).thenReturn('mockIdToken');

      // Mock Firebase Sign-In
      final credential = GoogleAuthProvider.credential(
        accessToken: 'mockAccessToken',
        idToken: 'mockIdToken',
      );
      when(mockFirebaseAuth.signInWithCredential(credential))
          .thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      final user = await authRepository.signInWithGoogle();

      expect(user, mockUser);
    });

    test('Google Sign-In should return null if user cancels', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final user = await authRepository.signInWithGoogle();

      expect(user, isNull);
    });

    test('Sign-Out should call FirebaseAuth.signOut', () async {
      await authRepository.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('getCurrentUser should return the current user', () {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final user = authRepository.getCurrentUser();

      expect(user, mockUser);
    });
  });
}
