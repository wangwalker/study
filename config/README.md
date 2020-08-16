# 各种工具的配置相关资源

## Java

####  Maven

基于项目对象模型(POM project object model)来管理项目的依赖关系，还是一个压缩工具。

一个典型的`pom.xml`文件中的`dependency`结构如下：
```xml
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-core</artifactId>
    <version>2.3.0</version>
</dependency>
```
`groupid`和`artifactId`被统称为“坐标”，为了保证项目唯一性。

- `groupId`: 组织的唯一标识符，例如`com.sum.*`，一般分为多个段，第一段为域，第二段为公司名称，后面的是更详细的分组信息；
- `artifactId`: 项目标识符，一般为项目名称；
- `version`: 版本号。

阿里云镜像：
```xml
<mirror>
    <id>alimaven</id>
    <name>aliyun maven</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    <mirrorOf>central</mirrorOf>        
</mirror>
<mirror>
    <id>alimaven</id>
    <mirrorOf>central</mirrorOf>
    <name>aliyun maven</name>
    <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
</mirror>
```

