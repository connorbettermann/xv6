
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 44             	sub    $0x44,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  14:	8d 45 d0             	lea    -0x30(%ebp),%eax
  17:	50                   	push   %eax
  18:	e8 57 04 00 00       	call   474 <date>
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	74 18                	je     3c <main+0x3c>
    printf(2,"Error: date call failed. %s at line %d\n",
  24:	6a 1c                	push   $0x1c
  26:	68 60 08 00 00       	push   $0x860
  2b:	68 e4 08 00 00       	push   $0x8e4
  30:	6a 02                	push   $0x2
  32:	e8 0f 05 00 00       	call   546 <printf>
        __FILE__, __LINE__);
    exit();
  37:	e8 90 03 00 00       	call   3cc <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  42:	8b 75 e0             	mov    -0x20(%ebp),%esi
  45:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
  48:	8d 7b fe             	lea    -0x2(%ebx),%edi
  4b:	83 fe 02             	cmp    $0x2,%esi
  4e:	0f 8e d5 00 00 00    	jle    129 <main+0x129>
  printf(1, "date.c called\n");
  54:	83 ec 08             	sub    $0x8,%esp
  57:	68 67 08 00 00       	push   $0x867
  5c:	6a 01                	push   $0x1
  5e:	e8 e3 04 00 00       	call   546 <printf>
  printf(1, "%s %s %d", days[day], months[r.month], r.day);
  63:	83 c4 04             	add    $0x4,%esp
  66:	ff 75 dc             	pushl  -0x24(%ebp)
  69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  6c:	ff 34 85 40 09 00 00 	pushl  0x940(,%eax,4)
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
  73:	6b c6 17             	imul   $0x17,%esi,%eax
  76:	b9 09 00 00 00       	mov    $0x9,%ecx
  7b:	99                   	cltd   
  7c:	f7 f9                	idiv   %ecx
  7e:	03 7d c4             	add    -0x3c(%ebp),%edi
  81:	8d 4c 38 04          	lea    0x4(%eax,%edi,1),%ecx
  85:	be 04 00 00 00       	mov    $0x4,%esi
  8a:	89 d8                	mov    %ebx,%eax
  8c:	99                   	cltd   
  8d:	f7 fe                	idiv   %esi
  8f:	01 c1                	add    %eax,%ecx
  91:	be 9c ff ff ff       	mov    $0xffffff9c,%esi
  96:	89 d8                	mov    %ebx,%eax
  98:	99                   	cltd   
  99:	f7 fe                	idiv   %esi
  9b:	01 c1                	add    %eax,%ecx
  9d:	be 90 01 00 00       	mov    $0x190,%esi
  a2:	89 d8                	mov    %ebx,%eax
  a4:	99                   	cltd   
  a5:	f7 fe                	idiv   %esi
  a7:	01 c8                	add    %ecx,%eax
  a9:	b9 07 00 00 00       	mov    $0x7,%ecx
  ae:	99                   	cltd   
  af:	f7 f9                	idiv   %ecx
  printf(1, "%s %s %d", days[day], months[r.month], r.day);
  b1:	ff 34 95 20 09 00 00 	pushl  0x920(,%edx,4)
  b8:	68 76 08 00 00       	push   $0x876
  bd:	6a 01                	push   $0x1
  bf:	e8 82 04 00 00       	call   546 <printf>
  printf(1, " ");
  c4:	83 c4 18             	add    $0x18,%esp
  c7:	68 7f 08 00 00       	push   $0x87f
  cc:	6a 01                	push   $0x1
  ce:	e8 73 04 00 00       	call   546 <printf>
  if (r.hour < 10) printf(1, "0");
  d3:	83 c4 10             	add    $0x10,%esp
  d6:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  da:	76 57                	jbe    133 <main+0x133>
  printf(1, "%d:", r.hour);
  dc:	83 ec 04             	sub    $0x4,%esp
  df:	ff 75 d8             	pushl  -0x28(%ebp)
  e2:	68 83 08 00 00       	push   $0x883
  e7:	6a 01                	push   $0x1
  e9:	e8 58 04 00 00       	call   546 <printf>
  if (r.minute < 10) printf(1, "0");
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
  f5:	76 50                	jbe    147 <main+0x147>
  printf(1, "%d:", r.minute);
  f7:	83 ec 04             	sub    $0x4,%esp
  fa:	ff 75 d4             	pushl  -0x2c(%ebp)
  fd:	68 83 08 00 00       	push   $0x883
 102:	6a 01                	push   $0x1
 104:	e8 3d 04 00 00       	call   546 <printf>
  if (r.second < 10) printf(1, "0");
 109:	83 c4 10             	add    $0x10,%esp
 10c:	83 7d d0 09          	cmpl   $0x9,-0x30(%ebp)
 110:	76 49                	jbe    15b <main+0x15b>
  printf(1, "%d UTC %d\n", r.second, r.year);
 112:	ff 75 e4             	pushl  -0x1c(%ebp)
 115:	ff 75 d0             	pushl  -0x30(%ebp)
 118:	68 87 08 00 00       	push   $0x887
 11d:	6a 01                	push   $0x1
 11f:	e8 22 04 00 00       	call   546 <printf>

  exit();
 124:	e8 a3 02 00 00       	call   3cc <exit>
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
 129:	89 df                	mov    %ebx,%edi
 12b:	8d 5b ff             	lea    -0x1(%ebx),%ebx
 12e:	e9 21 ff ff ff       	jmp    54 <main+0x54>
  if (r.hour < 10) printf(1, "0");
 133:	83 ec 08             	sub    $0x8,%esp
 136:	68 81 08 00 00       	push   $0x881
 13b:	6a 01                	push   $0x1
 13d:	e8 04 04 00 00       	call   546 <printf>
 142:	83 c4 10             	add    $0x10,%esp
 145:	eb 95                	jmp    dc <main+0xdc>
  if (r.minute < 10) printf(1, "0");
 147:	83 ec 08             	sub    $0x8,%esp
 14a:	68 81 08 00 00       	push   $0x881
 14f:	6a 01                	push   $0x1
 151:	e8 f0 03 00 00       	call   546 <printf>
 156:	83 c4 10             	add    $0x10,%esp
 159:	eb 9c                	jmp    f7 <main+0xf7>
  if (r.second < 10) printf(1, "0");
 15b:	83 ec 08             	sub    $0x8,%esp
 15e:	68 81 08 00 00       	push   $0x881
 163:	6a 01                	push   $0x1
 165:	e8 dc 03 00 00       	call   546 <printf>
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	eb a3                	jmp    112 <main+0x112>

0000016f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	53                   	push   %ebx
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 179:	89 c2                	mov    %eax,%edx
 17b:	83 c1 01             	add    $0x1,%ecx
 17e:	83 c2 01             	add    $0x1,%edx
 181:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 185:	88 5a ff             	mov    %bl,-0x1(%edx)
 188:	84 db                	test   %bl,%bl
 18a:	75 ef                	jne    17b <strcpy+0xc>
    ;
  return os;
}
 18c:	5b                   	pop    %ebx
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    

0000018f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	8b 4d 08             	mov    0x8(%ebp),%ecx
 195:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 198:	0f b6 01             	movzbl (%ecx),%eax
 19b:	84 c0                	test   %al,%al
 19d:	74 15                	je     1b4 <strcmp+0x25>
 19f:	3a 02                	cmp    (%edx),%al
 1a1:	75 11                	jne    1b4 <strcmp+0x25>
    p++, q++;
 1a3:	83 c1 01             	add    $0x1,%ecx
 1a6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a9:	0f b6 01             	movzbl (%ecx),%eax
 1ac:	84 c0                	test   %al,%al
 1ae:	74 04                	je     1b4 <strcmp+0x25>
 1b0:	3a 02                	cmp    (%edx),%al
 1b2:	74 ef                	je     1a3 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1b4:	0f b6 c0             	movzbl %al,%eax
 1b7:	0f b6 12             	movzbl (%edx),%edx
 1ba:	29 d0                	sub    %edx,%eax
}
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    

000001be <strlen>:

uint
strlen(char *s)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1c4:	80 39 00             	cmpb   $0x0,(%ecx)
 1c7:	74 12                	je     1db <strlen+0x1d>
 1c9:	ba 00 00 00 00       	mov    $0x0,%edx
 1ce:	83 c2 01             	add    $0x1,%edx
 1d1:	89 d0                	mov    %edx,%eax
 1d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1d7:	75 f5                	jne    1ce <strlen+0x10>
    ;
  return n;
}
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1db:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1e0:	eb f7                	jmp    1d9 <strlen+0x1b>

000001e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	57                   	push   %edi
 1e6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e9:	89 d7                	mov    %edx,%edi
 1eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	fc                   	cld    
 1f2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	5f                   	pop    %edi
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strchr>:

char*
strchr(const char *s, char c)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	53                   	push   %ebx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 203:	0f b6 10             	movzbl (%eax),%edx
 206:	84 d2                	test   %dl,%dl
 208:	74 1e                	je     228 <strchr+0x2f>
 20a:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 20c:	38 d3                	cmp    %dl,%bl
 20e:	74 15                	je     225 <strchr+0x2c>
  for(; *s; s++)
 210:	83 c0 01             	add    $0x1,%eax
 213:	0f b6 10             	movzbl (%eax),%edx
 216:	84 d2                	test   %dl,%dl
 218:	74 06                	je     220 <strchr+0x27>
    if(*s == c)
 21a:	38 ca                	cmp    %cl,%dl
 21c:	75 f2                	jne    210 <strchr+0x17>
 21e:	eb 05                	jmp    225 <strchr+0x2c>
      return (char*)s;
  return 0;
 220:	b8 00 00 00 00       	mov    $0x0,%eax
}
 225:	5b                   	pop    %ebx
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
  return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
 22d:	eb f6                	jmp    225 <strchr+0x2c>

0000022f <gets>:

char*
gets(char *buf, int max)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	57                   	push   %edi
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 23d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 240:	8d 5e 01             	lea    0x1(%esi),%ebx
 243:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 246:	7d 2b                	jge    273 <gets+0x44>
    cc = read(0, &c, 1);
 248:	83 ec 04             	sub    $0x4,%esp
 24b:	6a 01                	push   $0x1
 24d:	57                   	push   %edi
 24e:	6a 00                	push   $0x0
 250:	e8 8f 01 00 00       	call   3e4 <read>
    if(cc < 1)
 255:	83 c4 10             	add    $0x10,%esp
 258:	85 c0                	test   %eax,%eax
 25a:	7e 17                	jle    273 <gets+0x44>
      break;
    buf[i++] = c;
 25c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 260:	8b 55 08             	mov    0x8(%ebp),%edx
 263:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 267:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 269:	3c 0a                	cmp    $0xa,%al
 26b:	74 04                	je     271 <gets+0x42>
 26d:	3c 0d                	cmp    $0xd,%al
 26f:	75 cf                	jne    240 <gets+0x11>
  for(i=0; i+1 < max; ){
 271:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 27a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27d:	5b                   	pop    %ebx
 27e:	5e                   	pop    %esi
 27f:	5f                   	pop    %edi
 280:	5d                   	pop    %ebp
 281:	c3                   	ret    

00000282 <stat>:

int
stat(char *n, struct stat *st)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	56                   	push   %esi
 286:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 287:	83 ec 08             	sub    $0x8,%esp
 28a:	6a 00                	push   $0x0
 28c:	ff 75 08             	pushl  0x8(%ebp)
 28f:	e8 78 01 00 00       	call   40c <open>
  if(fd < 0)
 294:	83 c4 10             	add    $0x10,%esp
 297:	85 c0                	test   %eax,%eax
 299:	78 24                	js     2bf <stat+0x3d>
 29b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 29d:	83 ec 08             	sub    $0x8,%esp
 2a0:	ff 75 0c             	pushl  0xc(%ebp)
 2a3:	50                   	push   %eax
 2a4:	e8 7b 01 00 00       	call   424 <fstat>
 2a9:	89 c6                	mov    %eax,%esi
  close(fd);
 2ab:	89 1c 24             	mov    %ebx,(%esp)
 2ae:	e8 41 01 00 00       	call   3f4 <close>
  return r;
 2b3:	83 c4 10             	add    $0x10,%esp
}
 2b6:	89 f0                	mov    %esi,%eax
 2b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2bb:	5b                   	pop    %ebx
 2bc:	5e                   	pop    %esi
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    
    return -1;
 2bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c4:	eb f0                	jmp    2b6 <stat+0x34>

000002c6 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	56                   	push   %esi
 2ca:	53                   	push   %ebx
 2cb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2ce:	0f b6 0a             	movzbl (%edx),%ecx
 2d1:	80 f9 20             	cmp    $0x20,%cl
 2d4:	75 0b                	jne    2e1 <atoi+0x1b>
 2d6:	83 c2 01             	add    $0x1,%edx
 2d9:	0f b6 0a             	movzbl (%edx),%ecx
 2dc:	80 f9 20             	cmp    $0x20,%cl
 2df:	74 f5                	je     2d6 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 2e1:	80 f9 2d             	cmp    $0x2d,%cl
 2e4:	74 3b                	je     321 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 2e6:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2e9:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2ee:	f6 c1 fd             	test   $0xfd,%cl
 2f1:	74 33                	je     326 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 2f3:	0f b6 0a             	movzbl (%edx),%ecx
 2f6:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2f9:	3c 09                	cmp    $0x9,%al
 2fb:	77 2e                	ja     32b <atoi+0x65>
 2fd:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 302:	83 c2 01             	add    $0x1,%edx
 305:	8d 04 80             	lea    (%eax,%eax,4),%eax
 308:	0f be c9             	movsbl %cl,%ecx
 30b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 30f:	0f b6 0a             	movzbl (%edx),%ecx
 312:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 315:	80 fb 09             	cmp    $0x9,%bl
 318:	76 e8                	jbe    302 <atoi+0x3c>
  return sign*n;
 31a:	0f af c6             	imul   %esi,%eax
}
 31d:	5b                   	pop    %ebx
 31e:	5e                   	pop    %esi
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 321:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 326:	83 c2 01             	add    $0x1,%edx
 329:	eb c8                	jmp    2f3 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 32b:	b8 00 00 00 00       	mov    $0x0,%eax
 330:	eb e8                	jmp    31a <atoi+0x54>

00000332 <atoo>:

int
atoo(const char *s)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	56                   	push   %esi
 336:	53                   	push   %ebx
 337:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 33a:	0f b6 0a             	movzbl (%edx),%ecx
 33d:	80 f9 20             	cmp    $0x20,%cl
 340:	75 0b                	jne    34d <atoo+0x1b>
 342:	83 c2 01             	add    $0x1,%edx
 345:	0f b6 0a             	movzbl (%edx),%ecx
 348:	80 f9 20             	cmp    $0x20,%cl
 34b:	74 f5                	je     342 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 34d:	80 f9 2d             	cmp    $0x2d,%cl
 350:	74 38                	je     38a <atoo+0x58>
  if (*s == '+'  || *s == '-')
 352:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 355:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 35a:	f6 c1 fd             	test   $0xfd,%cl
 35d:	74 30                	je     38f <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 35f:	0f b6 0a             	movzbl (%edx),%ecx
 362:	8d 41 d0             	lea    -0x30(%ecx),%eax
 365:	3c 07                	cmp    $0x7,%al
 367:	77 2b                	ja     394 <atoo+0x62>
 369:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 36e:	83 c2 01             	add    $0x1,%edx
 371:	0f be c9             	movsbl %cl,%ecx
 374:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 378:	0f b6 0a             	movzbl (%edx),%ecx
 37b:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 37e:	80 fb 07             	cmp    $0x7,%bl
 381:	76 eb                	jbe    36e <atoo+0x3c>
  return sign*n;
 383:	0f af c6             	imul   %esi,%eax
}
 386:	5b                   	pop    %ebx
 387:	5e                   	pop    %esi
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 38a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 38f:	83 c2 01             	add    $0x1,%edx
 392:	eb cb                	jmp    35f <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 394:	b8 00 00 00 00       	mov    $0x0,%eax
 399:	eb e8                	jmp    383 <atoo+0x51>

0000039b <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	56                   	push   %esi
 39f:	53                   	push   %ebx
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	8b 75 0c             	mov    0xc(%ebp),%esi
 3a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a9:	85 db                	test   %ebx,%ebx
 3ab:	7e 13                	jle    3c0 <memmove+0x25>
 3ad:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 3b2:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3b6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3b9:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3bc:	39 d3                	cmp    %edx,%ebx
 3be:	75 f2                	jne    3b2 <memmove+0x17>
  return vdst;
}
 3c0:	5b                   	pop    %ebx
 3c1:	5e                   	pop    %esi
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    

000003c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c4:	b8 01 00 00 00       	mov    $0x1,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exit>:
SYSCALL(exit)
 3cc:	b8 02 00 00 00       	mov    $0x2,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <wait>:
SYSCALL(wait)
 3d4:	b8 03 00 00 00       	mov    $0x3,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <pipe>:
SYSCALL(pipe)
 3dc:	b8 04 00 00 00       	mov    $0x4,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <read>:
SYSCALL(read)
 3e4:	b8 05 00 00 00       	mov    $0x5,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <write>:
SYSCALL(write)
 3ec:	b8 10 00 00 00       	mov    $0x10,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <close>:
SYSCALL(close)
 3f4:	b8 15 00 00 00       	mov    $0x15,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <kill>:
SYSCALL(kill)
 3fc:	b8 06 00 00 00       	mov    $0x6,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <exec>:
SYSCALL(exec)
 404:	b8 07 00 00 00       	mov    $0x7,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <open>:
SYSCALL(open)
 40c:	b8 0f 00 00 00       	mov    $0xf,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <mknod>:
SYSCALL(mknod)
 414:	b8 11 00 00 00       	mov    $0x11,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <unlink>:
SYSCALL(unlink)
 41c:	b8 12 00 00 00       	mov    $0x12,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <fstat>:
SYSCALL(fstat)
 424:	b8 08 00 00 00       	mov    $0x8,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <link>:
SYSCALL(link)
 42c:	b8 13 00 00 00       	mov    $0x13,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <mkdir>:
SYSCALL(mkdir)
 434:	b8 14 00 00 00       	mov    $0x14,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <chdir>:
SYSCALL(chdir)
 43c:	b8 09 00 00 00       	mov    $0x9,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <dup>:
SYSCALL(dup)
 444:	b8 0a 00 00 00       	mov    $0xa,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <getpid>:
SYSCALL(getpid)
 44c:	b8 0b 00 00 00       	mov    $0xb,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <sbrk>:
SYSCALL(sbrk)
 454:	b8 0c 00 00 00       	mov    $0xc,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <sleep>:
SYSCALL(sleep)
 45c:	b8 0d 00 00 00       	mov    $0xd,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <uptime>:
SYSCALL(uptime)
 464:	b8 0e 00 00 00       	mov    $0xe,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <halt>:
SYSCALL(halt)
 46c:	b8 16 00 00 00       	mov    $0x16,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <date>:
SYSCALL(date)
 474:	b8 17 00 00 00       	mov    $0x17,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getuid>:
SYSCALL(getuid)
 47c:	b8 18 00 00 00       	mov    $0x18,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <getgid>:
SYSCALL(getgid)
 484:	b8 19 00 00 00       	mov    $0x19,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <getppid>:
SYSCALL(getppid)
 48c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <setuid>:
SYSCALL(setuid)
 494:	b8 1b 00 00 00       	mov    $0x1b,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <setgid>:
SYSCALL(setgid)
 49c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <getprocs>:
SYSCALL(getprocs)
 4a4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <setpriority>:
SYSCALL(setpriority)
 4ac:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <getpriority>:
SYSCALL(getpriority)
 4b4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	53                   	push   %ebx
 4c2:	83 ec 3c             	sub    $0x3c,%esp
 4c5:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4cb:	74 14                	je     4e1 <printint+0x25>
 4cd:	85 d2                	test   %edx,%edx
 4cf:	79 10                	jns    4e1 <printint+0x25>
    neg = 1;
    x = -xx;
 4d1:	f7 da                	neg    %edx
    neg = 1;
 4d3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4da:	bf 00 00 00 00       	mov    $0x0,%edi
 4df:	eb 0b                	jmp    4ec <printint+0x30>
  neg = 0;
 4e1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4e8:	eb f0                	jmp    4da <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 4ea:	89 df                	mov    %ebx,%edi
 4ec:	8d 5f 01             	lea    0x1(%edi),%ebx
 4ef:	89 d0                	mov    %edx,%eax
 4f1:	ba 00 00 00 00       	mov    $0x0,%edx
 4f6:	f7 f1                	div    %ecx
 4f8:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
 4ff:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 503:	89 c2                	mov    %eax,%edx
 505:	85 c0                	test   %eax,%eax
 507:	75 e1                	jne    4ea <printint+0x2e>
  if(neg)
 509:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 50d:	74 08                	je     517 <printint+0x5b>
    buf[i++] = '-';
 50f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 514:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 517:	83 eb 01             	sub    $0x1,%ebx
 51a:	78 22                	js     53e <printint+0x82>
  write(fd, &c, 1);
 51c:	8d 7d d7             	lea    -0x29(%ebp),%edi
 51f:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 524:	88 45 d7             	mov    %al,-0x29(%ebp)
 527:	83 ec 04             	sub    $0x4,%esp
 52a:	6a 01                	push   $0x1
 52c:	57                   	push   %edi
 52d:	56                   	push   %esi
 52e:	e8 b9 fe ff ff       	call   3ec <write>
  while(--i >= 0)
 533:	83 eb 01             	sub    $0x1,%ebx
 536:	83 c4 10             	add    $0x10,%esp
 539:	83 fb ff             	cmp    $0xffffffff,%ebx
 53c:	75 e1                	jne    51f <printint+0x63>
    putc(fd, buf[i]);
}
 53e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 541:	5b                   	pop    %ebx
 542:	5e                   	pop    %esi
 543:	5f                   	pop    %edi
 544:	5d                   	pop    %ebp
 545:	c3                   	ret    

00000546 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	57                   	push   %edi
 54a:	56                   	push   %esi
 54b:	53                   	push   %ebx
 54c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 54f:	8b 75 0c             	mov    0xc(%ebp),%esi
 552:	0f b6 1e             	movzbl (%esi),%ebx
 555:	84 db                	test   %bl,%bl
 557:	0f 84 b1 01 00 00    	je     70e <printf+0x1c8>
 55d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 560:	8d 45 10             	lea    0x10(%ebp),%eax
 563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 566:	bf 00 00 00 00       	mov    $0x0,%edi
 56b:	eb 2d                	jmp    59a <printf+0x54>
 56d:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	6a 01                	push   $0x1
 575:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 6b fe ff ff       	call   3ec <write>
 581:	83 c4 10             	add    $0x10,%esp
 584:	eb 05                	jmp    58b <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 586:	83 ff 25             	cmp    $0x25,%edi
 589:	74 22                	je     5ad <printf+0x67>
 58b:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 58e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 592:	84 db                	test   %bl,%bl
 594:	0f 84 74 01 00 00    	je     70e <printf+0x1c8>
    c = fmt[i] & 0xff;
 59a:	0f be d3             	movsbl %bl,%edx
 59d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5a0:	85 ff                	test   %edi,%edi
 5a2:	75 e2                	jne    586 <printf+0x40>
      if(c == '%'){
 5a4:	83 f8 25             	cmp    $0x25,%eax
 5a7:	75 c4                	jne    56d <printf+0x27>
        state = '%';
 5a9:	89 c7                	mov    %eax,%edi
 5ab:	eb de                	jmp    58b <printf+0x45>
      if(c == 'd'){
 5ad:	83 f8 64             	cmp    $0x64,%eax
 5b0:	74 59                	je     60b <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5b2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 5b8:	83 fa 70             	cmp    $0x70,%edx
 5bb:	74 7a                	je     637 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5bd:	83 f8 73             	cmp    $0x73,%eax
 5c0:	0f 84 9d 00 00 00    	je     663 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c6:	83 f8 63             	cmp    $0x63,%eax
 5c9:	0f 84 f2 00 00 00    	je     6c1 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5cf:	83 f8 25             	cmp    $0x25,%eax
 5d2:	0f 84 15 01 00 00    	je     6ed <printf+0x1a7>
 5d8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 5dc:	83 ec 04             	sub    $0x4,%esp
 5df:	6a 01                	push   $0x1
 5e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 ff fd ff ff       	call   3ec <write>
 5ed:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5f0:	83 c4 0c             	add    $0xc,%esp
 5f3:	6a 01                	push   $0x1
 5f5:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 eb fd ff ff       	call   3ec <write>
 601:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 604:	bf 00 00 00 00       	mov    $0x0,%edi
 609:	eb 80                	jmp    58b <printf+0x45>
        printint(fd, *ap, 10, 1);
 60b:	83 ec 0c             	sub    $0xc,%esp
 60e:	6a 01                	push   $0x1
 610:	b9 0a 00 00 00       	mov    $0xa,%ecx
 615:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 618:	8b 17                	mov    (%edi),%edx
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	e8 9a fe ff ff       	call   4bc <printint>
        ap++;
 622:	89 f8                	mov    %edi,%eax
 624:	83 c0 04             	add    $0x4,%eax
 627:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 62a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62d:	bf 00 00 00 00       	mov    $0x0,%edi
 632:	e9 54 ff ff ff       	jmp    58b <printf+0x45>
        printint(fd, *ap, 16, 0);
 637:	83 ec 0c             	sub    $0xc,%esp
 63a:	6a 00                	push   $0x0
 63c:	b9 10 00 00 00       	mov    $0x10,%ecx
 641:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 644:	8b 17                	mov    (%edi),%edx
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	e8 6e fe ff ff       	call   4bc <printint>
        ap++;
 64e:	89 f8                	mov    %edi,%eax
 650:	83 c0 04             	add    $0x4,%eax
 653:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 656:	83 c4 10             	add    $0x10,%esp
      state = 0;
 659:	bf 00 00 00 00       	mov    $0x0,%edi
 65e:	e9 28 ff ff ff       	jmp    58b <printf+0x45>
        s = (char*)*ap;
 663:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 666:	8b 01                	mov    (%ecx),%eax
        ap++;
 668:	83 c1 04             	add    $0x4,%ecx
 66b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 66e:	85 c0                	test   %eax,%eax
 670:	74 13                	je     685 <printf+0x13f>
        s = (char*)*ap;
 672:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 674:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 677:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 67c:	84 c0                	test   %al,%al
 67e:	75 0f                	jne    68f <printf+0x149>
 680:	e9 06 ff ff ff       	jmp    58b <printf+0x45>
          s = "(null)";
 685:	bb 74 09 00 00       	mov    $0x974,%ebx
        while(*s != 0){
 68a:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 68f:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 692:	89 75 d0             	mov    %esi,-0x30(%ebp)
 695:	8b 75 08             	mov    0x8(%ebp),%esi
 698:	88 45 e3             	mov    %al,-0x1d(%ebp)
 69b:	83 ec 04             	sub    $0x4,%esp
 69e:	6a 01                	push   $0x1
 6a0:	57                   	push   %edi
 6a1:	56                   	push   %esi
 6a2:	e8 45 fd ff ff       	call   3ec <write>
          s++;
 6a7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 6aa:	0f b6 03             	movzbl (%ebx),%eax
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	84 c0                	test   %al,%al
 6b2:	75 e4                	jne    698 <printf+0x152>
 6b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6b7:	bf 00 00 00 00       	mov    $0x0,%edi
 6bc:	e9 ca fe ff ff       	jmp    58b <printf+0x45>
        putc(fd, *ap);
 6c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6c4:	8b 07                	mov    (%edi),%eax
 6c6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6c9:	83 ec 04             	sub    $0x4,%esp
 6cc:	6a 01                	push   $0x1
 6ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6d1:	50                   	push   %eax
 6d2:	ff 75 08             	pushl  0x8(%ebp)
 6d5:	e8 12 fd ff ff       	call   3ec <write>
        ap++;
 6da:	83 c7 04             	add    $0x4,%edi
 6dd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6e0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6e3:	bf 00 00 00 00       	mov    $0x0,%edi
 6e8:	e9 9e fe ff ff       	jmp    58b <printf+0x45>
 6ed:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	6a 01                	push   $0x1
 6f5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 eb fc ff ff       	call   3ec <write>
 701:	83 c4 10             	add    $0x10,%esp
      state = 0;
 704:	bf 00 00 00 00       	mov    $0x0,%edi
 709:	e9 7d fe ff ff       	jmp    58b <printf+0x45>
    }
  }
}
 70e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 711:	5b                   	pop    %ebx
 712:	5e                   	pop    %esi
 713:	5f                   	pop    %edi
 714:	5d                   	pop    %ebp
 715:	c3                   	ret    

00000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	55                   	push   %ebp
 717:	89 e5                	mov    %esp,%ebp
 719:	57                   	push   %edi
 71a:	56                   	push   %esi
 71b:	53                   	push   %ebx
 71c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	a1 20 0c 00 00       	mov    0xc20,%eax
 727:	eb 0c                	jmp    735 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 729:	8b 10                	mov    (%eax),%edx
 72b:	39 c2                	cmp    %eax,%edx
 72d:	77 04                	ja     733 <free+0x1d>
 72f:	39 ca                	cmp    %ecx,%edx
 731:	77 10                	ja     743 <free+0x2d>
{
 733:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 735:	39 c8                	cmp    %ecx,%eax
 737:	73 f0                	jae    729 <free+0x13>
 739:	8b 10                	mov    (%eax),%edx
 73b:	39 ca                	cmp    %ecx,%edx
 73d:	77 04                	ja     743 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73f:	39 c2                	cmp    %eax,%edx
 741:	77 f0                	ja     733 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 743:	8b 73 fc             	mov    -0x4(%ebx),%esi
 746:	8b 10                	mov    (%eax),%edx
 748:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74b:	39 fa                	cmp    %edi,%edx
 74d:	74 19                	je     768 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 74f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 752:	8b 50 04             	mov    0x4(%eax),%edx
 755:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 758:	39 f1                	cmp    %esi,%ecx
 75a:	74 1b                	je     777 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 75c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 75e:	a3 20 0c 00 00       	mov    %eax,0xc20
}
 763:	5b                   	pop    %ebx
 764:	5e                   	pop    %esi
 765:	5f                   	pop    %edi
 766:	5d                   	pop    %ebp
 767:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 768:	03 72 04             	add    0x4(%edx),%esi
 76b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 12                	mov    (%edx),%edx
 772:	89 53 f8             	mov    %edx,-0x8(%ebx)
 775:	eb db                	jmp    752 <free+0x3c>
    p->s.size += bp->s.size;
 777:	03 53 fc             	add    -0x4(%ebx),%edx
 77a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 780:	89 10                	mov    %edx,(%eax)
 782:	eb da                	jmp    75e <free+0x48>

00000784 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	57                   	push   %edi
 788:	56                   	push   %esi
 789:	53                   	push   %ebx
 78a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	8d 58 07             	lea    0x7(%eax),%ebx
 793:	c1 eb 03             	shr    $0x3,%ebx
 796:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 799:	8b 15 20 0c 00 00    	mov    0xc20,%edx
 79f:	85 d2                	test   %edx,%edx
 7a1:	74 20                	je     7c3 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7a5:	8b 48 04             	mov    0x4(%eax),%ecx
 7a8:	39 cb                	cmp    %ecx,%ebx
 7aa:	76 3c                	jbe    7e8 <malloc+0x64>
 7ac:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7b2:	be 00 10 00 00       	mov    $0x1000,%esi
 7b7:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 7ba:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 7c1:	eb 70                	jmp    833 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 7c3:	c7 05 20 0c 00 00 24 	movl   $0xc24,0xc20
 7ca:	0c 00 00 
 7cd:	c7 05 24 0c 00 00 24 	movl   $0xc24,0xc24
 7d4:	0c 00 00 
    base.s.size = 0;
 7d7:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 7de:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7e1:	ba 24 0c 00 00       	mov    $0xc24,%edx
 7e6:	eb bb                	jmp    7a3 <malloc+0x1f>
      if(p->s.size == nunits)
 7e8:	39 cb                	cmp    %ecx,%ebx
 7ea:	74 1c                	je     808 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ec:	29 d9                	sub    %ebx,%ecx
 7ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7f4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7f7:	89 15 20 0c 00 00    	mov    %edx,0xc20
      return (void*)(p + 1);
 7fd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 800:	8d 65 f4             	lea    -0xc(%ebp),%esp
 803:	5b                   	pop    %ebx
 804:	5e                   	pop    %esi
 805:	5f                   	pop    %edi
 806:	5d                   	pop    %ebp
 807:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 808:	8b 08                	mov    (%eax),%ecx
 80a:	89 0a                	mov    %ecx,(%edx)
 80c:	eb e9                	jmp    7f7 <malloc+0x73>
  hp->s.size = nu;
 80e:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 811:	83 ec 0c             	sub    $0xc,%esp
 814:	83 c0 08             	add    $0x8,%eax
 817:	50                   	push   %eax
 818:	e8 f9 fe ff ff       	call   716 <free>
  return freep;
 81d:	8b 15 20 0c 00 00    	mov    0xc20,%edx
      if((p = morecore(nunits)) == 0)
 823:	83 c4 10             	add    $0x10,%esp
 826:	85 d2                	test   %edx,%edx
 828:	74 2b                	je     855 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 82c:	8b 48 04             	mov    0x4(%eax),%ecx
 82f:	39 d9                	cmp    %ebx,%ecx
 831:	73 b5                	jae    7e8 <malloc+0x64>
 833:	89 c2                	mov    %eax,%edx
    if(p == freep)
 835:	39 05 20 0c 00 00    	cmp    %eax,0xc20
 83b:	75 ed                	jne    82a <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 83d:	83 ec 0c             	sub    $0xc,%esp
 840:	57                   	push   %edi
 841:	e8 0e fc ff ff       	call   454 <sbrk>
  if(p == (char*)-1)
 846:	83 c4 10             	add    $0x10,%esp
 849:	83 f8 ff             	cmp    $0xffffffff,%eax
 84c:	75 c0                	jne    80e <malloc+0x8a>
        return 0;
 84e:	b8 00 00 00 00       	mov    $0x0,%eax
 853:	eb ab                	jmp    800 <malloc+0x7c>
 855:	b8 00 00 00 00       	mov    $0x0,%eax
 85a:	eb a4                	jmp    800 <malloc+0x7c>
