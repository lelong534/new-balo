# Flutter Chat SocketIO Bloc

> ## Nâng cao
>
> Đánh giá này dựa trên đánh giá của các ví dụ mẫu trên [Flutter Bloc Tutorial](https://bloclibrary.dev)

## Tổng quan
> Ta se đi xây dựng 2 khối chức năng là authentication và chat một một
> ## Key Topics
> - Manual authentication flow với một số authentication api và persist data
> - Chat via socketio

## Setup
Môi trường:
- Flutter 2.
- Enable Null Safety

Tạo một project mới và thêm vào `pubspec.yaml` một số phụ thuộc:

```
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^7.0.0
  equatable: ^2.0.2
  http: ^0.13.3
  shared_preferences: ^2.0.6
  socket_io_client: ^1.0.1
  loading_overlay: ^0.3.0
```

flutter_bloc, equatable để implement bloc cho flutter  
http để gọi api  
shared_preferences để persist data  
socket_io_client để giao tiếp với socket server  
loading_overlay để tạo lớp overlay khi loading request

___

Với ứng dụng bé, ta có thể phân chia code theo loại của các lớp, hàm. Ở đây, để app dễ mở rộng ta sẽ phân chia code theo chức năng.

Trong thư mục `lib`, tạo các thư mục sau: `splash`, `authentication`, `homepage`, `mesage`, `more`, `response_api_client`.

Mỗi thư mục này lại gồm một số thư mục sau: `blocs`, `models`, `repositories`, `widgets`, `helpers` (tùy vào khối chức năng nên một số thư mục sẽ không cần thiết).

## Authentication
### Data provider
Data provider là lớp thấp nhất trong kiến trúc bloc, về cơ bản nó chịu trách nhiệm các side effect.

Trong thư mục `repositories`, tạo `authentication_api_client.dart` và `authentication_persist.dart`, nghe tên là đã biết nó làm gì rồi đúng không nào.

Trước khi code 2 fle này, ta cần định nghĩa ra khuôn dạng cho dữ liệu trước. Trong thư mục `models`, tạo `user.dart`, và `user_main_info.dart`. Lớp `UserMainInfo` sẽ chứa id, name, avatar của một user. Do rất nhiều nơi trong ứng dụng chỉ cần 3 trường dữ liệu này nên ta tạo ra lớp này.

```dart
UserMainInfo userMainInfoFromJson(String str) =>
    UserMainInfo.fromJson(json.decode(str));

String userMainInfoToJson(UserMainInfo data) => json.encode(data.toJson());

class UserMainInfo {
  UserMainInfo({
    required this.id,
    required this.name,
    this.avatar,
  });

  String id;
  String name;
  String? avatar;

  factory UserMainInfo.fromJson(Map<String, dynamic> json) => UserMainInfo(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
      };
}
```

```dart
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.userMainInfo,
    required this.phonenumber,
    required this.password,
    required this.token,
  });

  UserMainInfo userMainInfo;
  String phonenumber;
  String password;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userMainInfo: UserMainInfo(
          id: json["id"],
          name: json["name"],
          avatar: json["avatar"],
        ),
        phonenumber: json["phonenumber"],
        password: json["password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": userMainInfo.id,
        "name": userMainInfo.name,
        "avatar": userMainInfo.avatar,
        "phonenumber": phonenumber,
        "password": password,
        "token": token,
      };
}
```

> Bạn có thể nhanh chóng tạo ra các model này qua [quicktype](https://app.quicktype.io/)

Giờ hãy quay trở lại `authentication_api_client.dart` và `authentication_persist.dart`:

```dart
class AuthenticationApiClient {
  Future<dynamic> signin({
    required String phonenumber,
    required String password,
  }) async {
    Uri url = Uri.https(
      'bk-zalo.herokuapp.com',
      '/api/login',
      {
        'phone_number': phonenumber,
        'password': password,
      },
    );
    http.Response response = await http.post(url);

    if (response.statusCode == 200) {
      ResponseApiClient responseApiClient =
          responseApiClientFromJson(response.body);

      if (responseApiClient.code == 1000) {
        return User(
          userMainInfo: UserMainInfo(
            id: responseApiClient.data!['id'].toString(),
            name: responseApiClient.data!['username'],
            avatar: responseApiClient.data!['avatar'],
          ),
          phonenumber: phonenumber,
          password: password,
          token: responseApiClient.data!['token'],
        );
      } else {
        return responseApiClient.message;
      }
    } else {
      return 'Something went wrong!';
    }
  }

  Future<void> signout({required String token}) async {
    Uri url = Uri.https(
      'bk-zalo.herokuapp.com',
      '/api/logout',
      {
        'token': token,
      },
    );
    await http.post(url);
  }
}
```

Lớp này gồm 2 phương thức `signin` và `signout`, `signin` sẽ gọi api đăng nhập và trả về user nếu thành công, trả về tin nhắn mô tả lỗi nếu thất bại, `signout` sẽ gọi api đăng xuất.

> Bạn sẽ băn khoăn lớp `ResponseApiClient` là gì và băn khoăn ở `signin`, tại sao tạo `user` lại phức tạp như vậy? Nếu bạn còn nhớ thì ở trên, khi tạo các thư mục theo chức năng, có một thư mục là `response_api_client`.
>
> Khi có nhiều lời gọi api, lớp `ResponseApiClient` sẽ phát huy tác dụng. Như tên lớp, nó là một lớp model đại diện cho response từ lời gọi api.
> 
>  Còn việc tạo `user` phức tạp là do việc không đồng bộ giữa api và các model ta đã định nghĩa, do vậy mà ta không tận dụng được các hàm chuyển đổi qua lại giữa object và json mà ta đã viết trong các lớp model.

Trong `response_api_client/models/`, tạo `response_api_client.dart`: (bạn có thể xem xét việc đặt tên thư mục này là `commom` và có thể đặt nhiều thứ vào trong hơn như tên của thư mục)

```dart
ResponseApiClient responseApiClientFromJson(String str) =>
    ResponseApiClient.fromJson(json.decode(str));

String responseApiClientToJson(ResponseApiClient data) =>
    json.encode(data.toJson());

class ResponseApiClient {
  ResponseApiClient({
    required this.code,
    required this.message,
    this.data,
  });

  int code;
  String message;
  Map<String, dynamic>? data;

  factory ResponseApiClient.fromJson(Map<String, dynamic> json) =>
      ResponseApiClient(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
```

> Từ đây, ta thấy sự quan trọng trong việc thiết kế trước khi lập trình. Cụ thể là thiết kế api, các api nên có khuôn dạng giống nhau (Ở đây, các response api đều gồm `code`, `message`, `data`. Nếu nó khác nhau, lớp `ResponseApiClient` cần gì phải có :smile:). Các trường dữ liệu trong `data` cũng nên thống nhất, không nên mô tả một thứ với nhiều tên như `name` và `username`, `phone` và `phonenumber`.

Luyên thuyên hơi nhiều, giờ quay trở lại `authentication_persist.dart`:

```dart
class AuthenticationPersist {
  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('user');
    if (json != null) {
      return userFromJson(json);
    } else {
      return null;
    }
  }

  Future<void> setUser({required User user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', userToJson(user));
  }

  Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
```

Lớp này thực hiện persist data để duy trì trạng thái đăng nhập sau những lần đóng ứng dụng.

### Repository
> Repository hiểu đơn giản là một wrapper của data provider, nó thể hiện việc trừu tượng giữa client code và data provider. Với những ứng dụng đơn giản, bạn sẽ thấy lớp này không hữu ích khi các phương thức của repository giống y hệt data provider. Với những ứng dụng lớn, một phương thức trong repository cần thực hiện bằng một vài phương thức trong data provider, và client code không cần biết một vài phương thức đó là gì, client code chỉ giao tiếp với repository.

Client code nghe có vẻ sai sai vì ta đang code ở client mà :smile:. Đọc tiếp và bạn sẽ biết nó là cái gì và đặt cho nó cái tên phù hợp hơn, mình cũng chưa biết đặt là gì cho phù hợp.

Trong thư mục `repositories`, tạo `authentication_repository.dart`
```dart
class AuthenticationRepository {
  final AuthenticationApiClient authenticationApiClient;

  final AuthenticationPersist authenticationPersist;

  AuthenticationRepository({
    required this.authenticationApiClient,
    required this.authenticationPersist,
  });

  Future<User?> getPersistenceUser() async {
    return authenticationPersist.getUser();
  }

  Future<void> setPersistenceUser({required User user}) async {
    await authenticationPersist.setUser(user: user);
  }

  Future<void> removePersistenceUser() async {
    await authenticationPersist.removeUser();
  }

  Future<dynamic> signin({
    required String phonenumber,
    required String password,
  }) async {
    return authenticationApiClient.signin(
      phonenumber: phonenumber,
      password: password,
    );
  }

  Future<void> signout({required String token}) async {
    await authenticationApiClient.signout(token: token);
  }
}
```

### Business Logic (Bloc)
> `AuthenticationBloc` sẽ nhận `AuthenticationEvent`, chuyển chúng thành `AuthenticationState`, nó sẽ phụ thuộc vào `AuthenticationRepository` để thực hiện các side effect.
>
> Bạn có thể tạo nhanh bloc code base bằng [VSCode Bloc Extension](https://bloclibrary.dev/#/blocvscodeextension)

Tong thư mục `blocs`, tạo `authentication_bloc.dart`, `authentication_event.dart`, `authentication_state.dart`:

```dart
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class Initialize extends AuthenticationEvent {}

class SignUp extends AuthenticationEvent {
  final String name;
  final String phonenumber;
  final String password;

  SignUp({
    required this.name,
    required this.phonenumber,
    required this.password,
  });

  @override
  List<Object> get props => [name, phonenumber, password];
}

class SignIn extends AuthenticationEvent {
  final String phonenumber;
  final String password;

  SignIn({required this.phonenumber, required this.password});

  @override
  List<Object> get props => [phonenumber, password];
}

class SignOut extends AuthenticationEvent {}
```

> Bạn nên hiểu về [equatable](https://pub.dev/packages/equatable), nó được áp dụng rất phổ biến với bloc.

Ta thấy có 4 event, `Initialize` xuất hiện ngay khi bạn mở ứng dụng để xem bạn đã đăng nhập hay chưa, 3 event còn lại thì chắc không cần giải thích gì rồi.

```dart
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthenticationState {}

class AuthenticationRequestLoading extends Unauthenticated {}

class AuthenticationRequestFailure extends Unauthenticated {
  final String message;

  AuthenticationRequestFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UnauthenticationRequestLoading extends Authenticated {
  UnauthenticationRequestLoading({required User user}) : super(user: user);
}
```

Đây là các trạng thái của authentication, bạn nên để ý kĩ lớp nào kế thừa lớp nào, lớp nào là abstract.

> Bạn có thể thấy sức mạnh của OOP trong việc thiết kế các event, state. Thiết kế đơn giản nhất là chỉ có một lớp event và một lớp state nhưng nó sẽ phải chứa tất cả các trường trong khi tại một số thời điểm, ta không cần hết các trường.
> 
> Thiết kế event, state như trên không phải hợp lý nhất, nhưng minh họa này cho ta thấy sự đa dạng trong việc thiết kế chúng, đặc biệt là `AuthenticationState` (kế thừa loạn cả lên :smile:) (đa dạng cũng đi kèm việc phức tạp và cần nhiều kinh nghiệm để có lựa chọn phù hợp với ứng dụng)
>
> Bạn có thể tham khảo thêm các cách thiết kế tốt hơn trên trang chủ của bloc: [login](https://bloclibrary.dev/#/flutterlogintutorial), [firebase login](https://bloclibrary.dev/#/flutterfirebaselogintutorial)

Tiếp tục với `AuthenticationBloc`:

```dart
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is Initialize) {
      User? user = await authenticationRepository.getPersistenceUser();

      if (user != null) {
        yield Authenticated(user: user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignIn) {
      yield AuthenticationRequestLoading();

      final signinResult = await authenticationRepository.signin(
        phonenumber: event.phonenumber,
        password: event.password,
      );

      if (signinResult is User) {
        await authenticationRepository.setPersistenceUser(user: signinResult);

        yield Authenticated(user: signinResult);
      } else {
        yield AuthenticationRequestFailure(message: signinResult);
      }
    } else if (event is SignOut) {
      if (state is Authenticated) {
        User user = state.props[0] as User;
        yield UnauthenticationRequestLoading(user: user);

        await authenticationRepository.removePersistenceUser();
        await authenticationRepository.signout(token: user.token);

        yield Unauthenticated();
      }
    }
  }
}
```

> Ở đây, bạn sẽ viết code cho Business Logic, bạn sẽ thấy không hề có data provider ở đây, trở lại với vấn đề đã đề cập ở trên là tách biệt client code và data provider, bạn giờ có thể đặt cho nó cái tên phù hợp hơn.

### Presentation
Như một thói quen, `BlocObserver` được tạo ra để bạn phát triển ứng dụng dễ hơn, bạn có thể quan sát chi tiết những gì đang xảy ra trong ứng dụng của bạn. (Còn việc triển khai để can thiệp vào logic của ứng dụng thì mình chưa rõ :smile:)

Trong thư mục `lib`, tạo `simple_bloc_observer.dart`:

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent $event');
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}
```

Mở `main.dart` và implement observer:

```dart
void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}
```

Tạo một instance `AuthenticationRepository`:

```dart
final authenticationRepository = AuthenticationRepository(
  authenticationApiClient: AuthenticationApiClient(),
  authenticationPersist: AuthenticationPersist(),
);
```

Truyền nó vào ứng dụng của ta:

```dart
runApp(MultiBlocProvider(
  providers: [
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      )..add(Initialize()),
    ),
    // ... other ...
  ],
  child: App(
    authenticationRepository: authenticationRepository,
  ),
));
```

> Bạn sẽ thấy hơi thừa, từ `MultiBlocProvider` đến có tận 2 `authenticationRepository`. Thực tế nó thừa thât :smile:, nhưng mình muốn minh họa cách gắn một repository vào ứng dụng. Bạn nên truyền nó vào `BlocProvider` ở cấp thấp nhất có thể. Truyền ở cấp cao nhất thì đơn giản rồi. Ở cấp thấp hơn ta truyền vào `App` như một thành viên lớp, thông qua hàm `build` của lớp này, đặt `BlocProvider` sao cho hợp lý.
>
> Bạn cũng nên để ý `..add(Initialize)`, nó bắn ra event ngay khi mở ứng dụng để kiểm tra trạng thái đăng nhập. (Hy vọng bạn đã biết đến cú pháp `..` trong dart)

Tạo `app.dart`:

```dart
class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  App({required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zalo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (_, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          } else if (state is Authenticated) {
            return Homepage();
          } else if (state is Unauthenticated) {
            return AuthenticationScreen();
          }

          return Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        },
      ),
    );
  }
}
```

> Như đã nêu vấn đề về repository, `App` ở đây không dùng đến repository, nhưng bằng cách này bạn có thể truyền nó vào `BlocProvider` ở một vị trí thích hợp trên widget tree.
>
> Về bản chất nó là như vậy, bạn có thể tìm hiểu thêm về `RepositoryProvider` và `MultiRepositoryProvider`, nó sẽ giúp bạn triển khai đơn giản hơn giống như này `context.read<RepositoryA>();`.

Trong `splash/widgets/`, tạo `splash_screen.dart`:

```dart
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
```

Đơn giản quá thì phải, bạn chịu khó vẽ ui theo sở thích nhé.

Trong `authentication/widgets/`, tạo các ui sau:

```dart
class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Text('ĐĂNG KÝ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninScreen(),
                  ),
                );
              },
              child: Text('ĐĂNG NHẬP'),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart
class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phonenumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is Authenticated) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (_, state) {
            return LoadingOverlay(
              isLoading: state is AuthenticationRequestLoading,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phonenumberController,
                      validator: (val) {
                        return val!.isEmpty
                            ? 'Vui lòng nhập số điện thoại!'
                            : null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (val) {
                        return val!.isEmpty ? 'Vui lòng nhập mật khẩu!' : null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();

            String phonenumber = _phonenumberController.text;
            String password = _passwordController.text;

            context
                .read<AuthenticationBloc>()
                .add(SignIn(phonenumber: phonenumber, password: password));
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  @override
  void dispose() {
    _phonenumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

> `LoadingOverlay` để tạo lớp overlay khi chờ đợi response api
> 
> `context.read<...>().add(...)` để bắn ra một event mới
>
> `BlocBuilder` để dựng ui theo state
>
> `BlocListener` để thực hiện thêm điều gì đó khi trạng thái ứng dụng thay đổi
>
> Nếu có cả `BlocBuilder` và `BlocListener`, bạn nên sử dụng `BlocConsumer` (đoạn code của ta cũng có thể dùng nó để gọn hơn, nếu viết `BlocConsumer` luôn sợ bạn không hiểu nên mình đã viết cách trên, bạn hãy viết lại nhé).

Đăng ký cũng tương tự như đăng nhập nhé. Nếu có khác thì chỉ khác ở tầng data provider, có thể ta cần gọi api đăng ký (chỉ trả về kết quả đăng ký thành công hay thất bại), sau dựa vào kết quả thành công hay thất bại mà gọi api đăng nhập để lấy những thứ như token. Nhưng client code của ta không cần biết điều đó. Ok, kiến trúc của ta có vể rất wonderful nhỉ :smile:.

Giờ ta xây dựng ui khi đăng nhập thành công.

Trong `homepage/widgets/`, tạo `homepage.dart`:

```dart
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: Text('Tìm bạn bè, tin nhắn...'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          MessageHomeScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Thêm',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        selectedFontSize: 12,
        selectedItemColor: Colors.lightBlueAccent.shade700,
        unselectedItemColor: Colors.grey.shade800,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
```

Còn một phần nữa là đăng xuất, bạn có thể đọc thêm ở mã nguồn, do phần chat cũng dài nên ta chỉ lướt những nội dung chính ở authentication thôi.

## Chat
### Data provider
Đầu tiên ta định nghĩa message model:

```dart
Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.sender,
    required this.receiver,
    required this.created,
    required this.content,
    required this.type,
  });

  UserMainInfo sender;
  UserMainInfo receiver;
  int created;
  String content;
  String type;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: UserMainInfo.fromJson(json["sender"]),
        receiver: UserMainInfo.fromJson(json["receiver"]),
        created: json["created"],
        content: json["content"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender.toJson(),
        "receiver": receiver.toJson(),
        "created": created,
        "content": content,
        "type": type,
      };
}
```

Để định danh một cuộc hội thoại, ta dựa vào một helper sau:

```dart
String getConversationId({
  required String senderId,
  required String receiverId,
}) {
  if (senderId.compareTo(receiverId) < 0) {
    return '$senderId-$receiverId';
  } else {
    return '$receiverId-$senderId';
  }
}
```

Chắc cũng không cần phải giải thích gì nhỉ :smile:

Phần chat sẽ hơi phức tạp, do nó phụ thuộc cả vào api lẫn socket, ta sẽ đi vào phần socket trước.

> Logic ở đây sẽ là khi đăng nhập (hoặc khi mở app đã đăng nhập), kết nối với socket server với định danh là id của tài khoản hiện tại. Khi đăng xuất sẽ ngắt kết nối với socket server.
>
> Logic phía socket server: Khi client kết nối, join vào một room có id room là id user (đã đính kèm khi client kết nối với server). Khi client ngắt kết nối thì leave room.
>
> Logic nhắn tin: Client emit event send cho server, server lắng nghe và emit event receive đến room tương ứng (mã room lấy được thông qua thông tin id của receiver trong message), client sẽ nhận được event receive này bằng việc đăng ký từ trước.

Code server:

```javascript
const app = require("express")();
const http = require("http").createServer(app);
const io = require("socket.io")(http);

app.get("/", (req, res) => {
  res.send("<h1>Hello world</h1>");
});

const PORT = process.env.PORT || 3000;

http.listen(PORT, () => {
  console.log(`Listening on *: ${PORT}`);
});

io.on("connection", (socket) => {
  console.log("User connected:", socket.handshake.headers.user_id, socket.id);

  const userId = socket.handshake.headers.user_id;
  socket.join(userId);

  socket.on("send", (jsonData) => {
    let data = JSON.parse(jsonData);
    console.log(userId, socket.id, "send:", jsonData);

    socket.in(data.receiver.id).emit("receive", jsonData);
  });

  socket.on("disconnect", () => {
    console.log("User disconnected:", userId, socket.id);
    socket.leave(userId);
  });
});
```

Tạo `socket_io_client.dart`:

```dart
class SocketIoClient {
  late Socket socket;
  bool init = false;

  void initialize() {
    socket = io(
      'https://zalochatserver.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket.onConnectError((e) {
      print('onConnectError: $e');
    });
  }

  void connect({required String userId}) {
    if (!init) {
      initialize();
      init = true;
    }

    socket.io.options['extraHeaders'] = {'user_id': userId};

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void sendMessage({required Message message}) {
    socket.emit('send', messageToJson(message));
  }

  void subscribeCallback({required String event, dynamic callback}) {
    socket.on(event, (jsonData) {
      print('event: $event: $jsonData');
      callback(jsonData);
    });
  }
}
```

Ta cần tách `initialize` và `connect` vì khi đăng xuất và đăng nhập lại bằng tài khoản khác, ta không cần `initialize` mà chỉ cần thay đổi `user_id` và connect lại với server. Tuy nhiên client code không cần biết điều này, ta chỉ cần cung cấp một phương thức `connect` tại repository. Lại một ví dụ về repository nhé :smile:.

Tạo `chat_api_client.dart`:

```dart
class ChatApiClient {
  Future<List<Message>> getMessages({
    required String senderId,
    required String receiverId,
  }) async {
    String conversationId = getConversationId(
      senderId: senderId,
      receiverId: receiverId,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('created')
        .get();

    List<Message> result = [];
    querySnapshot.docs.forEach((DocumentSnapshot element) {
      result.add(Message(
        sender: UserMainInfo.fromJson(element.data()!['sender']),
        receiver: UserMainInfo.fromJson(element.data()!['receiver']),
        created: element.data()!['created'],
        content: element.data()!['content'],
        type: element.data()!['type'],
      ));
    });

    return result;
  }

  Future<void> sendMessage({required Message message}) async {
    String conversationId = getConversationId(
      senderId: message.sender.id,
      receiverId: message.receiver.id,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'sender': message.sender.toJson(),
      'receiver': message.receiver.toJson(),
      'created': message.created,
      'content': message.content,
      'type': message.type,
    });
  }
}
```

Ở đây, để đơn giản, ta dùng firebase cloud firestore để minh họa chat api, nhưng nó là trong suốt với client code của ta. Ta có thể linh hoạt thay đổi api ở đây. Ok, có vẻ ta đã code đến level dễ sửa đổi nhỉ :smile:.

### Repository
Tạo `socket_io_repository.dart` và `chat_repository.dart`:

```dart
class SocketIoRepository {
  final SocketIoClient socketIoClient;

  SocketIoRepository({required this.socketIoClient});

  void connect({required String userId}) {
    socketIoClient.connect(userId: userId);
  }

  void disconnect() {
    socketIoClient.disconnect();
  }

  void sendMessage({required Message message}) {
    socketIoClient.sendMessage(message: message);
  }

  void subscribeReceiveCallback({dynamic callback}) {
    socketIoClient.subscribeCallback(event: 'receive', callback: callback);
  }
}
```

> Như đã trình bày ở trên, `SocketIoRepository` có giao tiếp với khối chức năng authentication, theo kiến trúc bloc, nó sẽ gắn vào tấng business logic, note tam ở đây cho đỡ quên :smile:, ta sẽ gắn nó vào sau.

```dart
class ChatRepository {
  final ChatApiClient chatApiClient;

  ChatRepository({required this.chatApiClient});

  Future<List<Message>> getMessages({
    required String senderId,
    required String receiverId,
  }) async {
    return chatApiClient.getMessages(
      senderId: senderId,
      receiverId: receiverId,
    );
  }

  Future<void> sendMessage({required Message message}) async {
    chatApiClient.sendMessage(message: message);
  }
}
```

### Business Logic (Bloc)
Ta thiết kế event và state dựa trên việc tại một thời điểm chỉ nhìn thấy được một màn hình chat.

Cụ thể, khi ta vào một màn hình chat, đầu tiên sẽ lấy các tin nhắn trước đó, lúc này nên hiện một lớp overlay đến khi lấy được các tin nhắn trước đó. Khi gửi tin nhắn, ta cần gọi phương thức `sendMessage` ở cả `chatRepository` và `socketIoRepository`.

Vậy việc nhận tin nhắn thì sao, logic ở đây sẽ hơi khác và phức tạp một chút. Bạn cần tạo ta một hành vi sẽ xảy ra khi app nhận được event `receive` từ socket server. Sau khi tạo xong bạn gắn nó vào cái gọi là `onEvent`. Hành vi là bắn ra event `RecieveMessage`.

Câu hỏi là gắn khi nào? Tương tự như việc kiểm tra trạng thái đăng nhập khi mở app, bạn sẽ đăng ký cái này khi lần đầu tiên bạn mở một màn hình nhắn tin. Bạn sẽ thắc mắc là tại sao không phải là ngay sau khi đăng nhập thành công (hoặc mở app đã đăng nhập), bởi vì đây là bloc cho màn hình nhắn tin chứ không phải màn hình chứa danh sách các hội thoại (việc đăng ký ứng với bloc này đương nhiên là ngay sau khi đăng nhập - mở app đã đăng nhập).

```dart
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRequested extends MessageEvent {
  final String senderId;
  final String receiverId;

  GetMessagesRequested({required this.senderId, required this.receiverId});

  @override
  List<Object> get props => [senderId, receiverId];
}

class ResetMessages extends MessageEvent {}

class SendMessage extends MessageEvent {
  final UserMainInfo sender;
  final UserMainInfo receiver;
  final String content;

  SendMessage({
    required this.sender,
    required this.receiver,
    required this.content,
  });

  @override
  List<Object> get props => [sender, receiver, content];
}

class RecieveMessage extends MessageEvent {
  final Message message;

  RecieveMessage({required this.message});

  @override
  List<Object> get props => [message];
}
```

Có 4 event, `GetMessagesRequested` ứng với lấy các tin nhắn trước đó, `ResetMessages` ứng với thoát khỏi màn hình nhắn tin (do tại một thời điểm chỉ có một màn hình nhắn tin mà lại có nhiều hội thoại, nếu không có event này khi bạn vào một màn hình nhắn tin rồi qua màn hình nhắn tin khác, bạn sẽ thấy một lớp overlay đè lên các tin nhắn cũ ở màn hình nhắn tin trước), 2 event còn lại dễ rồi.

3 event đầu sẽ do ta chủ động bắn ra, còn event `RecieveMessage` sẽ bắn ra khi socket server emit event `receive`.

```dart
class MessageState extends Equatable {
  final List<Message> messages;
  final bool loading;
  final String receiverId;

  const MessageState({
    required this.messages,
    required this.loading,
    required this.receiverId,
  });

  @override
  List<Object> get props => [messages, loading, receiverId];
}
```

Đây là minh họa cho việc tạo state bằng 1 class duy nhất mà chứa tất cả các trường thông tin. Ở đây có `receiverId` là để khi ta nhận được event `RecieveMessage`, ta sẽ kiểm tra xem ta có đang ở trong màn hình nhắn tin hay không (`receiverId` sẽ có giá trị khi ở trong một màn hình nhắn tin), khi đang ở màn hình nhắn tin rồi thì kiểm tra xem tin nhắn đó có thuộc cuộc hội thoại này không, tránh việc cứ có người gửi tin nhắn đến là thêm luôn vào màn hình hiện tại trong khi nó chưa chắc thuộc về hội thoại này.

```dart
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;
  final SocketIoRepository socketIoRepository;
  bool subscribed = false;

  MessageBloc({required this.chatRepository, required this.socketIoRepository})
      : super(MessageState(messages: [], loading: false, receiverId: ''));

  void subscribe({dynamic receiveCallback}) {
    socketIoRepository.subscribeReceiveCallback(callback: receiveCallback);
    subscribed = true;
  }

  getReiceiveCallbacl() {
    return (String jsonData) {
      add(RecieveMessage(message: messageFromJson(jsonData)));
    };
  }

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is GetMessagesRequested) {
      yield MessageState(
        messages: [],
        loading: true,
        receiverId: event.receiverId,
      );

      List<Message> messages = await chatRepository.getMessages(
        senderId: event.senderId,
        receiverId: event.receiverId,
      );
      yield MessageState(
        messages: messages,
        loading: false,
        receiverId: event.receiverId,
      );
    } else if (event is ResetMessages) {
      yield MessageState(messages: [], loading: false, receiverId: '');
    } else if (event is SendMessage) {
      Message message = Message(
        sender: event.sender,
        receiver: event.receiver,
        created: DateTime.now().millisecondsSinceEpoch,
        content: event.content,
        type: 'text',
      );

      chatRepository.sendMessage(message: message);
      socketIoRepository.sendMessage(message: message);

      yield MessageState(
        messages: [...state.messages, message],
        loading: false,
        receiverId: state.receiverId,
      );
    } else if (event is RecieveMessage) {
      if (state.receiverId == event.message.sender.id) {
        yield MessageState(
          messages: [...state.messages, event.message],
          loading: false,
          receiverId: state.receiverId,
        );
      }
    }
  }
}
```

Những thứ như `subscribed`, `subscribe()`, `getReiceiveCallbacl()` để đăng ký hành vi cho event `ReceiveMessage`. Hiện tại lời gọi đến những thứ này nằm trong tầng presentation.

Bạn có thể xem xét giải pháp việc gọi nó ở trong constructor của `MesageBloc`, điều quan trọng là cái callback bạn đăng ký phải tồn tại tại thời điểm bạn gọi phương thức `subscribeReceiveCallback()` của lớp `SocketIoRepository` (đoạn này hơi trừu tượng, mình chỉ biết giải thích như vậy thôi). Và do code chạy rồi nên mình cũng chưa suy nghĩ về giải pháp tự động đăng ký ở constructor.

> Nếu bạn muốn suy nghĩ về vấn đề này, bạn cần biết là constructor này được gọi khi có một `BlocBuilder`dựa vào bloc này được gắn vào widget tree chứ không phải là `BlocProvider`.

Bạn còn nhớ việc `SocketIoRepository` có giao tiếp với khối chức năng authentication đã note ở trên không?

```dart
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final SocketIoRepository socketIoRepository; //

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.socketIoRepository, //
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is Initialize) {
      User? user = await authenticationRepository.getPersistenceUser();

      if (user != null) {
        socketIoRepository.connect(userId: user.userMainInfo.id); //

        yield Authenticated(user: user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignIn) {
      yield AuthenticationRequestLoading();

      final signinResult = await authenticationRepository.signin(
        phonenumber: event.phonenumber,
        password: event.password,
      );

      if (signinResult is User) {
        socketIoRepository.connect(userId: signinResult.userMainInfo.id); //

        await authenticationRepository.setPersistenceUser(user: signinResult);

        yield Authenticated(user: signinResult);
      } else {
        yield AuthenticationRequestFailure(message: signinResult);
      }
    } else if (event is SignOut) {
      if (state is Authenticated) {
        socketIoRepository.disconnect(); //

        User user = state.props[0] as User;
        yield UnauthenticationRequestLoading(user: user);

        await authenticationRepository.removePersistenceUser();
        await authenticationRepository.signout(token: user.token);

        yield Unauthenticated();
      }
    }
  }
}
```

Những dòng có thêm `//` ở cuối là code mới. Code cũng khá là dễ sửa đổi phải không :smile:?

Đương nhiên bạn cũng cần sửa lại hàm main:

```dart
runApp(MultiBlocProvider(
  providers: [
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authenticationRepository: authenticationRepository,
        socketIoRepository: socketIoRepository, // new
      )..add(Initialize()),
    ),
    BlocProvider<MessageBloc>( // new
      create: (context) => MessageBloc(
        chatRepository: chatRepository,
        socketIoRepository: socketIoRepository,
      ),
    ),
  ],
  child: App(
    authenticationRepository: authenticationRepository,
  ),
));
```

### Presentation
Tạo `mesage_home_screen.dart` là màn hình đầu tiên sau khi đăng nhập, khi phát triển thêm nó sẽ chứa danh sách các cuộc hội thoại:

```dart
class MessageHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DummySearchScreen(),
              ),
            );
          },
          child: Text('TÌM THÊM BẠN'),
        )
      ],
    );
  }
}
```

Tiếp theo, tạo `dummy_search_screen.dart`, y như tên gọi, nó đơn giản chỉ hiển thị vài user cố định.

```dart
class DummySearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {'id': '103', 'name': 'Tường Vy', 'avatar': null},
      {'id': '104', 'name': 'Minh Ngọc', 'avatar': null},
      {'id': '105', 'name': 'Quỳnh Mai', 'avatar': null},
      {'id': '106', 'name': 'Bảo Thy', 'avatar': null},
      {'id': '107', 'name': 'Kiều Trang', 'avatar': null},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy Search'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            User user = state.user;
            final filterDummyData = dummyData
                .where((element) => element['id'] != user.userMainInfo.id)
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: filterDummyData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text(
                      filterDummyData[index]['name']![0].toUpperCase(),
                    ),
                  ),
                  title: Text(filterDummyData[index]['name'].toString()),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            receiver: UserMainInfo(
                              id: filterDummyData[index]['id'].toString(),
                              name: filterDummyData[index]['name'].toString(),
                              avatar:
                                  filterDummyData[index]['avatar']?.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.chat_rounded),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
```

Các thông tin dummy này đều đúng bởi ta đã đăng ký trước các tài khoản này.

Thông tin các tài khoản gồm số điên thoại, mật khẩu, name, id

```
0868868101 - 12345678 - Tường Vy - 103
0868868102 - 12345678 - Minh Ngọc - 104
0868868103 - 12345678 - Quỳnh Mai - 105
0868868104 - 12345678 - Bảo Thy - 106
0868868105 - 12345678 - Kiều Trang - 107
```

Cuối cùng là `mesage_screen.dart`:

```dart
class MessageScreen extends StatefulWidget {
  final UserMainInfo receiver;

  MessageScreen({required this.receiver});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();

    AuthenticationState authenticationState =
        context.read<AuthenticationBloc>().state;
    if (authenticationState is Authenticated) {
      user = authenticationState.user;

      context.read<MessageBloc>().add(GetMessagesRequested(
            senderId: user.userMainInfo.id,
            receiverId: widget.receiver.id,
          ));
    }
  }

  Future<bool> _pop() {
    context.read<MessageBloc>().add(ResetMessages());
    return Future.value(true);
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<MessageBloc>().add(SendMessage(
            sender: user.userMainInfo,
            receiver: widget.receiver,
            content: _messageController.text,
          ));

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _pop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.name),
        ),
        body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            MessageBloc messageBloc = context.read<MessageBloc>();
            if (!messageBloc.subscribed) {
              messageBloc.subscribe(
                receiveCallback: messageBloc.getReiceiveCallbacl(),
              );
            }

            return LoadingOverlay(
              isLoading: state.loading,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return Text(state.messages[index].content);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Tin nhắn',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Material(
                            child: IconButton(
                              onPressed: _sendMessage,
                              icon: Icon(Icons.send_rounded),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
```

That’s all there is to it!

Mã nguồn: [here](https://github.com/TrangNguyen99/flutter-zalo-bloc)
