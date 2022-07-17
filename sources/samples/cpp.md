% cpp
% zdszero
% 2022-07-17

* __assert with message__

```cpp
#ifdef DEBUG
#define ASSERT(condition, message)                                       \
  do {                                                                   \
    if (!(condition)) {                                                  \
      std::cerr << "Assertion `" #condition "` failed in " << __FILE__   \
                << " line " << __LINE__ << ": " << message << std::endl; \
      std::terminate();                                                  \
    }                                                                    \
  } while (false)
#else
#define ASSERT(condition, message) \
  do {                             \
  } while (false)
#endif
```

* __random string__

```cpp
std::string random_string(size_t length) {
  auto randchar = []() -> char {
    const char charset[] =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";
    const size_t max_index = (sizeof(charset) - 1);
    return charset[rand() % max_index];
  };
  std::string str(length, 0);
  std::generate_n(str.begin(), length, randchar);
  return str;
}
```

* __parallel test__

```cpp
template <typename ... Args>
void LaunchParallelTest(size_t thread_num, Args&& ...args) {
  std::vector<std::thread> thread_group;
  for (size_t i = 0; i < thread_num; i++) {
    thread_group.push_back(std::thread(args...));
  }
  for (size_t i = 0; i < thread_num; i++) {
    if (thread_group[i].joinable()) {
        thread_group[i].join();
    }
  }
}
```
