% coding
% zdszero
% 2022-07-10

## 编解码

leveldb中使用little endian

__int__

```cpp
void EncodeFixed32(char* dst, uint32_t value) {
    // clang and gcc will optimize this to a single mov/str instruction
    uint8_t* const buffer = reinterpret_cast<uint8_t*>(dst);
    buffer[0] = static_cast<uint8_t>(value);
    buffer[1] = static_cast<uint8_t>(value >> 8);
    buffer[2] = static_cast<uint8_t>(value >> 16);
    buffer[3] = static_cast<uint8_t>(value >> 24);
}

uint32_t DecodeFixed32(const char *ptr) {
    const uint8_t * const buffer = reinterpret_cast<uint8_t*>(ptr);
    return (static_cast<uint32_t>(buffer[0])) |
           (static_cast<uint32_t>(buffer[1]) << 8) |
           (static_cast<uint32_t>(buffer[2]) << 16) |
           (static_cast<uint32_t>(buffer[3]) << 24);
}
```
__varint__

varint中的每个字节的最高位（bit）有特殊含义，如果该位为1，表示后续的字节也是这个数字的一部分，如果该位为0，则结束。其他的7位（bit）都表示数字。

对于很小的int32类型的数字，则可以用1个字节来表示。当然凡事都有好的也有不好的一面，采用varint表示法，大的数字则可能需要5个字节来表示。从统计的角度来说，一般不会所有消息中的数字都是大数，因此大多数情况下，采用varint后，可以用更小的字节数来表示数字信息。

比如对于uint32_t 300，其二进制表示是(1 0010 1100)，varint用两个字节表示300，为(0000 0010, 1010 1100)

```cpp
char* EncodeVarint32(char *dst, uint32_t v) {
    uint8_t* const ptr = reinterpret_cast<uint8_t*>(dst);
    uint8_t M = 128; // mask setting the 8th bit to 1 in a byte
    if (v < (1 << 7)) {
        *(ptr++) = v;
    } else if (v < (1 << 14)) {
        *(ptr++) = v | B;   // casted to uint8_t
        *(ptr++) = v >> 7;
    } else if (v < (1 << 21)) {
        *(ptr++) = v | B;
        *(ptr++) = (v >> 7) | B;
        *(ptr++) = v >> 14;
    } else if (v < (1 << 28)) {
        *(ptr++) = v | B;
        *(ptr++) = (v >> 7) | B;
        *(ptr++) = (v >> 14) | B;
        *(ptr++) = v >> 21;
    } else {
        *(ptr++) = v | B;
        *(ptr++) = (v >> 7) | B;
        *(ptr++) = (v >> 14) | B;
        *(ptr++) = (v >> 21) | B;
        *(ptr++) = v >> 28;
    }
    return reinterpret_cast<char *>(ptr);
}

uint32_t DecodeVarint32(const char *ptr) {
    const uint8_t* p = reinterpret_cast<uint8_t*>(ptr);
    uint32_t res = 0;
    int shift = 0;
    while (*p & 128) {
        res |= ((*p & 127) << shift);
        shift += 7;
        p++;
    }
    res |= (*p << shift);
    return res;
}
```
