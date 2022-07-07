% arary
% zdszero
% 2022-07-07


* __mid_search, lower_bound, upper_bound__

```c
int mid_search(int a[], int n, int x) {
    int l = 0;
    int h = n;
    while (l < h) {
        int mid = l + (h - l) / 2;
        if (a[mid] == x) {
            return mid;
        } else if (a[mid] < x) {
            l = mid + 1;
        } else {
            r = mid;
        }
    }
    return -1;
}

int lower_bound(int a[], int n, int x) {
    int l = 0;
    int h = n;
    while (l < h) {
        int mid = l + (h - l) / 2;
        if (x <= a[mid]) {
            h = mid;
        } else {
            l = mid + 1;
        }
    }
    return l;
}

int upper_bound(int a[], int n, int x) {
    int l = 0;
    int h = n;
    while (l < h) {
        int mid = l + (h - l) / 2;
        if (x >= a[mid]) {
            l = mid + 1;
        } else {
            h = mid;
        }
    }
    return l;
}
```

lower_bound和upper_bound的不同之处，在于判断a[mid] == target时如何放置l和h，这两个算法最后寻找到的位置一定是l == h

如果放置h = mid，那么最后落点一定在这个位置，如果放置l = mid + 1，最后落点一定在mid + 1的位置。
