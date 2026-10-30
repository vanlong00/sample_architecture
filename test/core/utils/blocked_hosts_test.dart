import 'package:busmod/core/utils/blocked_hosts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool b(String u) => isBlockedHost(Uri.parse(u));

  test('blocks the source hosts and subdomains', () {
    expect(b('https://mediafire.com/file/x'), isTrue);
    expect(b('https://www.mediafire.com/file/x'), isTrue);
    expect(b('http://download123.mediafire.com/x'), isTrue);
    expect(b('https://f000.backblazeb2.com/file/x'), isTrue);
    expect(b('https://backblazeb2.com'), isTrue);
    expect(b('https://www.backblaze.com'), isTrue);
  });

  test('is case-insensitive and ignores a trailing dot', () {
    expect(b('https://WWW.MediaFire.COM/x'), isTrue);
    expect(b('https://www.mediafire.com./x'), isTrue);
    expect(b('https://F000.BackblazeB2.com./x'), isTrue);
  });

  test('userinfo tricks are decided by the real host', () {
    expect(b('https://evil.com@www.mediafire.com/x'), isTrue);
    expect(b('https://www.mediafire.com@evil.com/x'), isFalse);
    expect(b('https://user:pw@f1.backblazeb2.com/x'), isTrue);
  });

  test('allows lookalikes and others', () {
    expect(b('https://notmediafire.com'), isFalse);
    expect(b('https://mediafire.com.evil.com'), isFalse);
    expect(b('https://evil.com/mediafire.com'), isFalse);
    expect(b('https://backblazeb2.com.evil.io'), isFalse);
    expect(b('https://cdn.example.com'), isFalse);
  });

  test('scheme is irrelevant; relative/malformed have no host', () {
    expect(b('ftp://www.mediafire.com/x'), isTrue);
    expect(b('/relative'), isFalse);
    expect(isBlockedHost(Uri()), isFalse);
    expect(isBlockedHost(Uri.parse('mailto:a@mediafire.com')), isFalse);
  });
}
