
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 20 0b 00 00       	push   $0xb20
  15:	56                   	push   %esi
  16:	e8 55 03 00 00       	call   370 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 20 0b 00 00       	push   $0xb20
  2d:	6a 01                	push   $0x1
  2f:	e8 44 03 00 00       	call   378 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 e8 07 00 00       	push   $0x7e8
  43:	6a 01                	push   $0x1
  45:	e8 88 04 00 00       	call   4d2 <printf>
      exit();
  4a:	e8 09 03 00 00       	call   358 <exit>
    }
  }
  if(n < 0){
  4f:	85 c0                	test   %eax,%eax
  51:	78 07                	js     5a <cat+0x5a>
    printf(1, "cat: read error\n");
    exit();
  }
}
  53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  56:	5b                   	pop    %ebx
  57:	5e                   	pop    %esi
  58:	5d                   	pop    %ebp
  59:	c3                   	ret    
    printf(1, "cat: read error\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 fa 07 00 00       	push   $0x7fa
  62:	6a 01                	push   $0x1
  64:	e8 69 04 00 00       	call   4d2 <printf>
    exit();
  69:	e8 ea 02 00 00       	call   358 <exit>

0000006e <main>:

int
main(int argc, char *argv[])
{
  6e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  72:	83 e4 f0             	and    $0xfffffff0,%esp
  75:	ff 71 fc             	pushl  -0x4(%ecx)
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	56                   	push   %esi
  7d:	53                   	push   %ebx
  7e:	51                   	push   %ecx
  7f:	83 ec 18             	sub    $0x18,%esp
  82:	8b 01                	mov    (%ecx),%eax
  84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  87:	8b 59 04             	mov    0x4(%ecx),%ebx
  8a:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  8d:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  92:	83 f8 01             	cmp    $0x1,%eax
  95:	7e 3c                	jle    d3 <main+0x65>
    if((fd = open(argv[i], 0)) < 0){
  97:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	6a 00                	push   $0x0
  9f:	ff 33                	pushl  (%ebx)
  a1:	e8 f2 02 00 00       	call   398 <open>
  a6:	89 c6                	mov    %eax,%esi
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	85 c0                	test   %eax,%eax
  ad:	78 33                	js     e2 <main+0x74>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	50                   	push   %eax
  b3:	e8 48 ff ff ff       	call   0 <cat>
    close(fd);
  b8:	89 34 24             	mov    %esi,(%esp)
  bb:	e8 c0 02 00 00       	call   380 <close>
  for(i = 1; i < argc; i++){
  c0:	83 c7 01             	add    $0x1,%edi
  c3:	83 c3 04             	add    $0x4,%ebx
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  cc:	75 c9                	jne    97 <main+0x29>
  }
  exit();
  ce:	e8 85 02 00 00       	call   358 <exit>
    cat(0);
  d3:	83 ec 0c             	sub    $0xc,%esp
  d6:	6a 00                	push   $0x0
  d8:	e8 23 ff ff ff       	call   0 <cat>
    exit();
  dd:	e8 76 02 00 00       	call   358 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  e2:	83 ec 04             	sub    $0x4,%esp
  e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e8:	ff 30                	pushl  (%eax)
  ea:	68 0b 08 00 00       	push   $0x80b
  ef:	6a 01                	push   $0x1
  f1:	e8 dc 03 00 00       	call   4d2 <printf>
      exit();
  f6:	e8 5d 02 00 00       	call   358 <exit>

000000fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	53                   	push   %ebx
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 105:	89 c2                	mov    %eax,%edx
 107:	83 c1 01             	add    $0x1,%ecx
 10a:	83 c2 01             	add    $0x1,%edx
 10d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 111:	88 5a ff             	mov    %bl,-0x1(%edx)
 114:	84 db                	test   %bl,%bl
 116:	75 ef                	jne    107 <strcpy+0xc>
    ;
  return os;
}
 118:	5b                   	pop    %ebx
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 121:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 124:	0f b6 01             	movzbl (%ecx),%eax
 127:	84 c0                	test   %al,%al
 129:	74 15                	je     140 <strcmp+0x25>
 12b:	3a 02                	cmp    (%edx),%al
 12d:	75 11                	jne    140 <strcmp+0x25>
    p++, q++;
 12f:	83 c1 01             	add    $0x1,%ecx
 132:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 135:	0f b6 01             	movzbl (%ecx),%eax
 138:	84 c0                	test   %al,%al
 13a:	74 04                	je     140 <strcmp+0x25>
 13c:	3a 02                	cmp    (%edx),%al
 13e:	74 ef                	je     12f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 140:	0f b6 c0             	movzbl %al,%eax
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	29 d0                	sub    %edx,%eax
}
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strlen>:

uint
strlen(char *s)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 150:	80 39 00             	cmpb   $0x0,(%ecx)
 153:	74 12                	je     167 <strlen+0x1d>
 155:	ba 00 00 00 00       	mov    $0x0,%edx
 15a:	83 c2 01             	add    $0x1,%edx
 15d:	89 d0                	mov    %edx,%eax
 15f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 163:	75 f5                	jne    15a <strlen+0x10>
    ;
  return n;
}
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
  for(n = 0; s[n]; n++)
 167:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 16c:	eb f7                	jmp    165 <strlen+0x1b>

0000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	57                   	push   %edi
 172:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 175:	89 d7                	mov    %edx,%edi
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	fc                   	cld    
 17e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 180:	89 d0                	mov    %edx,%eax
 182:	5f                   	pop    %edi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <strchr>:

char*
strchr(const char *s, char c)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	53                   	push   %ebx
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 18f:	0f b6 10             	movzbl (%eax),%edx
 192:	84 d2                	test   %dl,%dl
 194:	74 1e                	je     1b4 <strchr+0x2f>
 196:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 198:	38 d3                	cmp    %dl,%bl
 19a:	74 15                	je     1b1 <strchr+0x2c>
  for(; *s; s++)
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	0f b6 10             	movzbl (%eax),%edx
 1a2:	84 d2                	test   %dl,%dl
 1a4:	74 06                	je     1ac <strchr+0x27>
    if(*s == c)
 1a6:	38 ca                	cmp    %cl,%dl
 1a8:	75 f2                	jne    19c <strchr+0x17>
 1aa:	eb 05                	jmp    1b1 <strchr+0x2c>
      return (char*)s;
  return 0;
 1ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b1:	5b                   	pop    %ebx
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
  return 0;
 1b4:	b8 00 00 00 00       	mov    $0x0,%eax
 1b9:	eb f6                	jmp    1b1 <strchr+0x2c>

000001bb <gets>:

char*
gets(char *buf, int max)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
 1be:	57                   	push   %edi
 1bf:	56                   	push   %esi
 1c0:	53                   	push   %ebx
 1c1:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c4:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1c9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1cc:	8d 5e 01             	lea    0x1(%esi),%ebx
 1cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d2:	7d 2b                	jge    1ff <gets+0x44>
    cc = read(0, &c, 1);
 1d4:	83 ec 04             	sub    $0x4,%esp
 1d7:	6a 01                	push   $0x1
 1d9:	57                   	push   %edi
 1da:	6a 00                	push   $0x0
 1dc:	e8 8f 01 00 00       	call   370 <read>
    if(cc < 1)
 1e1:	83 c4 10             	add    $0x10,%esp
 1e4:	85 c0                	test   %eax,%eax
 1e6:	7e 17                	jle    1ff <gets+0x44>
      break;
    buf[i++] = c;
 1e8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1ec:	8b 55 08             	mov    0x8(%ebp),%edx
 1ef:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1f3:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1f5:	3c 0a                	cmp    $0xa,%al
 1f7:	74 04                	je     1fd <gets+0x42>
 1f9:	3c 0d                	cmp    $0xd,%al
 1fb:	75 cf                	jne    1cc <gets+0x11>
  for(i=0; i+1 < max; ){
 1fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 206:	8d 65 f4             	lea    -0xc(%ebp),%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <stat>:

int
stat(char *n, struct stat *st)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	56                   	push   %esi
 212:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 213:	83 ec 08             	sub    $0x8,%esp
 216:	6a 00                	push   $0x0
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 78 01 00 00       	call   398 <open>
  if(fd < 0)
 220:	83 c4 10             	add    $0x10,%esp
 223:	85 c0                	test   %eax,%eax
 225:	78 24                	js     24b <stat+0x3d>
 227:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	pushl  0xc(%ebp)
 22f:	50                   	push   %eax
 230:	e8 7b 01 00 00       	call   3b0 <fstat>
 235:	89 c6                	mov    %eax,%esi
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
 23a:	e8 41 01 00 00       	call   380 <close>
  return r;
 23f:	83 c4 10             	add    $0x10,%esp
}
 242:	89 f0                	mov    %esi,%eax
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5d                   	pop    %ebp
 24a:	c3                   	ret    
    return -1;
 24b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 250:	eb f0                	jmp    242 <stat+0x34>

00000252 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	56                   	push   %esi
 256:	53                   	push   %ebx
 257:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 25a:	0f b6 0a             	movzbl (%edx),%ecx
 25d:	80 f9 20             	cmp    $0x20,%cl
 260:	75 0b                	jne    26d <atoi+0x1b>
 262:	83 c2 01             	add    $0x1,%edx
 265:	0f b6 0a             	movzbl (%edx),%ecx
 268:	80 f9 20             	cmp    $0x20,%cl
 26b:	74 f5                	je     262 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 26d:	80 f9 2d             	cmp    $0x2d,%cl
 270:	74 3b                	je     2ad <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 272:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 275:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 27a:	f6 c1 fd             	test   $0xfd,%cl
 27d:	74 33                	je     2b2 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 27f:	0f b6 0a             	movzbl (%edx),%ecx
 282:	8d 41 d0             	lea    -0x30(%ecx),%eax
 285:	3c 09                	cmp    $0x9,%al
 287:	77 2e                	ja     2b7 <atoi+0x65>
 289:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 28e:	83 c2 01             	add    $0x1,%edx
 291:	8d 04 80             	lea    (%eax,%eax,4),%eax
 294:	0f be c9             	movsbl %cl,%ecx
 297:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 29b:	0f b6 0a             	movzbl (%edx),%ecx
 29e:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2a1:	80 fb 09             	cmp    $0x9,%bl
 2a4:	76 e8                	jbe    28e <atoi+0x3c>
  return sign*n;
 2a6:	0f af c6             	imul   %esi,%eax
}
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 2ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 2b2:	83 c2 01             	add    $0x1,%edx
 2b5:	eb c8                	jmp    27f <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 2b7:	b8 00 00 00 00       	mov    $0x0,%eax
 2bc:	eb e8                	jmp    2a6 <atoi+0x54>

000002be <atoo>:

int
atoo(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	56                   	push   %esi
 2c2:	53                   	push   %ebx
 2c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2c6:	0f b6 0a             	movzbl (%edx),%ecx
 2c9:	80 f9 20             	cmp    $0x20,%cl
 2cc:	75 0b                	jne    2d9 <atoo+0x1b>
 2ce:	83 c2 01             	add    $0x1,%edx
 2d1:	0f b6 0a             	movzbl (%edx),%ecx
 2d4:	80 f9 20             	cmp    $0x20,%cl
 2d7:	74 f5                	je     2ce <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 2d9:	80 f9 2d             	cmp    $0x2d,%cl
 2dc:	74 38                	je     316 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 2de:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2e1:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2e6:	f6 c1 fd             	test   $0xfd,%cl
 2e9:	74 30                	je     31b <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 2eb:	0f b6 0a             	movzbl (%edx),%ecx
 2ee:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2f1:	3c 07                	cmp    $0x7,%al
 2f3:	77 2b                	ja     320 <atoo+0x62>
 2f5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 2fa:	83 c2 01             	add    $0x1,%edx
 2fd:	0f be c9             	movsbl %cl,%ecx
 300:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 304:	0f b6 0a             	movzbl (%edx),%ecx
 307:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 30a:	80 fb 07             	cmp    $0x7,%bl
 30d:	76 eb                	jbe    2fa <atoo+0x3c>
  return sign*n;
 30f:	0f af c6             	imul   %esi,%eax
}
 312:	5b                   	pop    %ebx
 313:	5e                   	pop    %esi
 314:	5d                   	pop    %ebp
 315:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 316:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 31b:	83 c2 01             	add    $0x1,%edx
 31e:	eb cb                	jmp    2eb <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 320:	b8 00 00 00 00       	mov    $0x0,%eax
 325:	eb e8                	jmp    30f <atoo+0x51>

00000327 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	56                   	push   %esi
 32b:	53                   	push   %ebx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	8b 75 0c             	mov    0xc(%ebp),%esi
 332:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 335:	85 db                	test   %ebx,%ebx
 337:	7e 13                	jle    34c <memmove+0x25>
 339:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 33e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 342:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 345:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 348:	39 d3                	cmp    %edx,%ebx
 34a:	75 f2                	jne    33e <memmove+0x17>
  return vdst;
}
 34c:	5b                   	pop    %ebx
 34d:	5e                   	pop    %esi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <write>:
SYSCALL(write)
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <close>:
SYSCALL(close)
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <open>:
SYSCALL(open)
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <uptime>:
SYSCALL(uptime)
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <halt>:
SYSCALL(halt)
 3f8:	b8 16 00 00 00       	mov    $0x16,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <date>:
SYSCALL(date)
 400:	b8 17 00 00 00       	mov    $0x17,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getuid>:
SYSCALL(getuid)
 408:	b8 18 00 00 00       	mov    $0x18,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <getgid>:
SYSCALL(getgid)
 410:	b8 19 00 00 00       	mov    $0x19,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <getppid>:
SYSCALL(getppid)
 418:	b8 1a 00 00 00       	mov    $0x1a,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <setuid>:
SYSCALL(setuid)
 420:	b8 1b 00 00 00       	mov    $0x1b,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <setgid>:
SYSCALL(setgid)
 428:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <getprocs>:
SYSCALL(getprocs)
 430:	b8 1d 00 00 00       	mov    $0x1d,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <setpriority>:
SYSCALL(setpriority)
 438:	b8 1e 00 00 00       	mov    $0x1e,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <getpriority>:
SYSCALL(getpriority)
 440:	b8 1f 00 00 00       	mov    $0x1f,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	57                   	push   %edi
 44c:	56                   	push   %esi
 44d:	53                   	push   %ebx
 44e:	83 ec 3c             	sub    $0x3c,%esp
 451:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 457:	74 14                	je     46d <printint+0x25>
 459:	85 d2                	test   %edx,%edx
 45b:	79 10                	jns    46d <printint+0x25>
    neg = 1;
    x = -xx;
 45d:	f7 da                	neg    %edx
    neg = 1;
 45f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 466:	bf 00 00 00 00       	mov    $0x0,%edi
 46b:	eb 0b                	jmp    478 <printint+0x30>
  neg = 0;
 46d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 474:	eb f0                	jmp    466 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 476:	89 df                	mov    %ebx,%edi
 478:	8d 5f 01             	lea    0x1(%edi),%ebx
 47b:	89 d0                	mov    %edx,%eax
 47d:	ba 00 00 00 00       	mov    $0x0,%edx
 482:	f7 f1                	div    %ecx
 484:	0f b6 92 28 08 00 00 	movzbl 0x828(%edx),%edx
 48b:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 48f:	89 c2                	mov    %eax,%edx
 491:	85 c0                	test   %eax,%eax
 493:	75 e1                	jne    476 <printint+0x2e>
  if(neg)
 495:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 499:	74 08                	je     4a3 <printint+0x5b>
    buf[i++] = '-';
 49b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4a0:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 4a3:	83 eb 01             	sub    $0x1,%ebx
 4a6:	78 22                	js     4ca <printint+0x82>
  write(fd, &c, 1);
 4a8:	8d 7d d7             	lea    -0x29(%ebp),%edi
 4ab:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 4b0:	88 45 d7             	mov    %al,-0x29(%ebp)
 4b3:	83 ec 04             	sub    $0x4,%esp
 4b6:	6a 01                	push   $0x1
 4b8:	57                   	push   %edi
 4b9:	56                   	push   %esi
 4ba:	e8 b9 fe ff ff       	call   378 <write>
  while(--i >= 0)
 4bf:	83 eb 01             	sub    $0x1,%ebx
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	83 fb ff             	cmp    $0xffffffff,%ebx
 4c8:	75 e1                	jne    4ab <printint+0x63>
    putc(fd, buf[i]);
}
 4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5f                   	pop    %edi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    

000004d2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	57                   	push   %edi
 4d6:	56                   	push   %esi
 4d7:	53                   	push   %ebx
 4d8:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4db:	8b 75 0c             	mov    0xc(%ebp),%esi
 4de:	0f b6 1e             	movzbl (%esi),%ebx
 4e1:	84 db                	test   %bl,%bl
 4e3:	0f 84 b1 01 00 00    	je     69a <printf+0x1c8>
 4e9:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 4ec:	8d 45 10             	lea    0x10(%ebp),%eax
 4ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 4f2:	bf 00 00 00 00       	mov    $0x0,%edi
 4f7:	eb 2d                	jmp    526 <printf+0x54>
 4f9:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 4fc:	83 ec 04             	sub    $0x4,%esp
 4ff:	6a 01                	push   $0x1
 501:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 6b fe ff ff       	call   378 <write>
 50d:	83 c4 10             	add    $0x10,%esp
 510:	eb 05                	jmp    517 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 512:	83 ff 25             	cmp    $0x25,%edi
 515:	74 22                	je     539 <printf+0x67>
 517:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 51a:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 51e:	84 db                	test   %bl,%bl
 520:	0f 84 74 01 00 00    	je     69a <printf+0x1c8>
    c = fmt[i] & 0xff;
 526:	0f be d3             	movsbl %bl,%edx
 529:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 52c:	85 ff                	test   %edi,%edi
 52e:	75 e2                	jne    512 <printf+0x40>
      if(c == '%'){
 530:	83 f8 25             	cmp    $0x25,%eax
 533:	75 c4                	jne    4f9 <printf+0x27>
        state = '%';
 535:	89 c7                	mov    %eax,%edi
 537:	eb de                	jmp    517 <printf+0x45>
      if(c == 'd'){
 539:	83 f8 64             	cmp    $0x64,%eax
 53c:	74 59                	je     597 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 53e:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 544:	83 fa 70             	cmp    $0x70,%edx
 547:	74 7a                	je     5c3 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 549:	83 f8 73             	cmp    $0x73,%eax
 54c:	0f 84 9d 00 00 00    	je     5ef <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 552:	83 f8 63             	cmp    $0x63,%eax
 555:	0f 84 f2 00 00 00    	je     64d <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 55b:	83 f8 25             	cmp    $0x25,%eax
 55e:	0f 84 15 01 00 00    	je     679 <printf+0x1a7>
 564:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 568:	83 ec 04             	sub    $0x4,%esp
 56b:	6a 01                	push   $0x1
 56d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 ff fd ff ff       	call   378 <write>
 579:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 57c:	83 c4 0c             	add    $0xc,%esp
 57f:	6a 01                	push   $0x1
 581:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 584:	50                   	push   %eax
 585:	ff 75 08             	pushl  0x8(%ebp)
 588:	e8 eb fd ff ff       	call   378 <write>
 58d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 590:	bf 00 00 00 00       	mov    $0x0,%edi
 595:	eb 80                	jmp    517 <printf+0x45>
        printint(fd, *ap, 10, 1);
 597:	83 ec 0c             	sub    $0xc,%esp
 59a:	6a 01                	push   $0x1
 59c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5a4:	8b 17                	mov    (%edi),%edx
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	e8 9a fe ff ff       	call   448 <printint>
        ap++;
 5ae:	89 f8                	mov    %edi,%eax
 5b0:	83 c0 04             	add    $0x4,%eax
 5b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b9:	bf 00 00 00 00       	mov    $0x0,%edi
 5be:	e9 54 ff ff ff       	jmp    517 <printf+0x45>
        printint(fd, *ap, 16, 0);
 5c3:	83 ec 0c             	sub    $0xc,%esp
 5c6:	6a 00                	push   $0x0
 5c8:	b9 10 00 00 00       	mov    $0x10,%ecx
 5cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5d0:	8b 17                	mov    (%edi),%edx
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	e8 6e fe ff ff       	call   448 <printint>
        ap++;
 5da:	89 f8                	mov    %edi,%eax
 5dc:	83 c0 04             	add    $0x4,%eax
 5df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5e2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e5:	bf 00 00 00 00       	mov    $0x0,%edi
 5ea:	e9 28 ff ff ff       	jmp    517 <printf+0x45>
        s = (char*)*ap;
 5ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 5f2:	8b 01                	mov    (%ecx),%eax
        ap++;
 5f4:	83 c1 04             	add    $0x4,%ecx
 5f7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5fa:	85 c0                	test   %eax,%eax
 5fc:	74 13                	je     611 <printf+0x13f>
        s = (char*)*ap;
 5fe:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 600:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 603:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 608:	84 c0                	test   %al,%al
 60a:	75 0f                	jne    61b <printf+0x149>
 60c:	e9 06 ff ff ff       	jmp    517 <printf+0x45>
          s = "(null)";
 611:	bb 20 08 00 00       	mov    $0x820,%ebx
        while(*s != 0){
 616:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 61b:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 61e:	89 75 d0             	mov    %esi,-0x30(%ebp)
 621:	8b 75 08             	mov    0x8(%ebp),%esi
 624:	88 45 e3             	mov    %al,-0x1d(%ebp)
 627:	83 ec 04             	sub    $0x4,%esp
 62a:	6a 01                	push   $0x1
 62c:	57                   	push   %edi
 62d:	56                   	push   %esi
 62e:	e8 45 fd ff ff       	call   378 <write>
          s++;
 633:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 636:	0f b6 03             	movzbl (%ebx),%eax
 639:	83 c4 10             	add    $0x10,%esp
 63c:	84 c0                	test   %al,%al
 63e:	75 e4                	jne    624 <printf+0x152>
 640:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 643:	bf 00 00 00 00       	mov    $0x0,%edi
 648:	e9 ca fe ff ff       	jmp    517 <printf+0x45>
        putc(fd, *ap);
 64d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 650:	8b 07                	mov    (%edi),%eax
 652:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 655:	83 ec 04             	sub    $0x4,%esp
 658:	6a 01                	push   $0x1
 65a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 65d:	50                   	push   %eax
 65e:	ff 75 08             	pushl  0x8(%ebp)
 661:	e8 12 fd ff ff       	call   378 <write>
        ap++;
 666:	83 c7 04             	add    $0x4,%edi
 669:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 66c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66f:	bf 00 00 00 00       	mov    $0x0,%edi
 674:	e9 9e fe ff ff       	jmp    517 <printf+0x45>
 679:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 67c:	83 ec 04             	sub    $0x4,%esp
 67f:	6a 01                	push   $0x1
 681:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 684:	50                   	push   %eax
 685:	ff 75 08             	pushl  0x8(%ebp)
 688:	e8 eb fc ff ff       	call   378 <write>
 68d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 690:	bf 00 00 00 00       	mov    $0x0,%edi
 695:	e9 7d fe ff ff       	jmp    517 <printf+0x45>
    }
  }
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    

000006a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a2:	55                   	push   %ebp
 6a3:	89 e5                	mov    %esp,%ebp
 6a5:	57                   	push   %edi
 6a6:	56                   	push   %esi
 6a7:	53                   	push   %ebx
 6a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ab:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ae:	a1 00 0b 00 00       	mov    0xb00,%eax
 6b3:	eb 0c                	jmp    6c1 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	39 c2                	cmp    %eax,%edx
 6b9:	77 04                	ja     6bf <free+0x1d>
 6bb:	39 ca                	cmp    %ecx,%edx
 6bd:	77 10                	ja     6cf <free+0x2d>
{
 6bf:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	39 c8                	cmp    %ecx,%eax
 6c3:	73 f0                	jae    6b5 <free+0x13>
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	39 ca                	cmp    %ecx,%edx
 6c9:	77 04                	ja     6cf <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cb:	39 c2                	cmp    %eax,%edx
 6cd:	77 f0                	ja     6bf <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6cf:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6d7:	39 fa                	cmp    %edi,%edx
 6d9:	74 19                	je     6f4 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6db:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6e4:	39 f1                	cmp    %esi,%ecx
 6e6:	74 1b                	je     703 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6e8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6ea:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6f4:	03 72 04             	add    0x4(%edx),%esi
 6f7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fa:	8b 10                	mov    (%eax),%edx
 6fc:	8b 12                	mov    (%edx),%edx
 6fe:	89 53 f8             	mov    %edx,-0x8(%ebx)
 701:	eb db                	jmp    6de <free+0x3c>
    p->s.size += bp->s.size;
 703:	03 53 fc             	add    -0x4(%ebx),%edx
 706:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 709:	8b 53 f8             	mov    -0x8(%ebx),%edx
 70c:	89 10                	mov    %edx,(%eax)
 70e:	eb da                	jmp    6ea <free+0x48>

00000710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	8d 58 07             	lea    0x7(%eax),%ebx
 71f:	c1 eb 03             	shr    $0x3,%ebx
 722:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 725:	8b 15 00 0b 00 00    	mov    0xb00,%edx
 72b:	85 d2                	test   %edx,%edx
 72d:	74 20                	je     74f <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 731:	8b 48 04             	mov    0x4(%eax),%ecx
 734:	39 cb                	cmp    %ecx,%ebx
 736:	76 3c                	jbe    774 <malloc+0x64>
 738:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 73e:	be 00 10 00 00       	mov    $0x1000,%esi
 743:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 746:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 74d:	eb 70                	jmp    7bf <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 74f:	c7 05 00 0b 00 00 04 	movl   $0xb04,0xb00
 756:	0b 00 00 
 759:	c7 05 04 0b 00 00 04 	movl   $0xb04,0xb04
 760:	0b 00 00 
    base.s.size = 0;
 763:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 76a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 76d:	ba 04 0b 00 00       	mov    $0xb04,%edx
 772:	eb bb                	jmp    72f <malloc+0x1f>
      if(p->s.size == nunits)
 774:	39 cb                	cmp    %ecx,%ebx
 776:	74 1c                	je     794 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 778:	29 d9                	sub    %ebx,%ecx
 77a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 77d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 780:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 783:	89 15 00 0b 00 00    	mov    %edx,0xb00
      return (void*)(p + 1);
 789:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 78c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78f:	5b                   	pop    %ebx
 790:	5e                   	pop    %esi
 791:	5f                   	pop    %edi
 792:	5d                   	pop    %ebp
 793:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 794:	8b 08                	mov    (%eax),%ecx
 796:	89 0a                	mov    %ecx,(%edx)
 798:	eb e9                	jmp    783 <malloc+0x73>
  hp->s.size = nu;
 79a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 79d:	83 ec 0c             	sub    $0xc,%esp
 7a0:	83 c0 08             	add    $0x8,%eax
 7a3:	50                   	push   %eax
 7a4:	e8 f9 fe ff ff       	call   6a2 <free>
  return freep;
 7a9:	8b 15 00 0b 00 00    	mov    0xb00,%edx
      if((p = morecore(nunits)) == 0)
 7af:	83 c4 10             	add    $0x10,%esp
 7b2:	85 d2                	test   %edx,%edx
 7b4:	74 2b                	je     7e1 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7b8:	8b 48 04             	mov    0x4(%eax),%ecx
 7bb:	39 d9                	cmp    %ebx,%ecx
 7bd:	73 b5                	jae    774 <malloc+0x64>
 7bf:	89 c2                	mov    %eax,%edx
    if(p == freep)
 7c1:	39 05 00 0b 00 00    	cmp    %eax,0xb00
 7c7:	75 ed                	jne    7b6 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 7c9:	83 ec 0c             	sub    $0xc,%esp
 7cc:	57                   	push   %edi
 7cd:	e8 0e fc ff ff       	call   3e0 <sbrk>
  if(p == (char*)-1)
 7d2:	83 c4 10             	add    $0x10,%esp
 7d5:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d8:	75 c0                	jne    79a <malloc+0x8a>
        return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb ab                	jmp    78c <malloc+0x7c>
 7e1:	b8 00 00 00 00       	mov    $0x0,%eax
 7e6:	eb a4                	jmp    78c <malloc+0x7c>
