# 简介

Django是Python最流行的Web开发框架，因为优秀的架构设计和Python的众多能力，功能强大，易于使用。

## 适用场景

Django适用的场景包括：
- 内容管理系统
    - 博客
    - CMS
    - Wiki
- 企业内部系统
    - ERP、CRM
    - 招聘系统
    - 报表系统
    - 会议系统
- 运维管理系统
    - CMDB
    - 作业发布
    - 作业管理
    - 脚本管理
    - 故障管理

## 特点

- 优点
    - Python代码，代码干净、整洁
    - 自带管理后台，能够快速开发
    - 复用度高，设计遵循DRY原则
    - 易于扩展的中间件机制
    - 内置的安全框架
    - 丰富的第三方类库
- 缺点
    - 单体应用，不易并行开发
    - 不适合非常小的项目
    - 不适合高并发的C端项目

## 基本使用

基本的使用方法：

```s

# 创建项目
django-admin startproject project_name  # 老版本
django startproject project_name        # 新版本呢

# 创建应用，先要进入项目根目录
python manage startapp app_name

# 迁移数据库
python manage makemigrations
python manage migrate

# 检查语法
python manage check

# 从已有数据库中反省，得到Models
python manage inspectdb table_name > app_name/models.py

# 启动项目
python manage runserver 
python manage runserver 0.0.0.0:8000
# 通过 --settings 指定项目配置文件
python manage runserver 0.0.0.0:8000 --settings somemodule.somesettings

```

# 创建模型


# 模版
## 模版继承

首先在应用中新建一个文件夹“templates”，在里面创建base.html, detail.html。

在base：

```html
{% block header %}
<div style="margin-left: 5px;display: -webkit-flex;display: flex;">
...
<!-- 继承的内容会出现在这里 -->
{% endblock %}

{% block content %}
<!-- 继承的内容会出现在这里 -->
{% endblock %}
```

在detail中：

```html
{% extends 'base.html' %}

{% block header %}
<!-- 具体的内容 -->
{% endblock %}

{% block content %}
<!-- 具体的内容 -->
{% endblock %}
```



# 动作
## 命令行动作

Django提供了自定义命令行行为的方法，在app下创建management/commands文件夹，在里面自定义一个名字，比如import_candidates.py

```python
import csv
from django.core.management import BaseCommand
from interview.models import Candidate

# 使用方式为：python manage.py import_candidates --path /path/to/your/file.csv
class Command(BaseCommand):
    help = "从CSV文件中导入候选人信息"

    # 添加自定义参数
    def add_arguments(self, parser):
        parser.add_argument('--path', type=str)

    # 处理逻辑
    def handle(self, *args, **kwargs):
        path = kwargs['path']
        with open(path, 'rt', encoding="gbk") as f:
            reader = csv.reader(f, dialect='excel', delimiter=';')
            for row in reader:
                candidate = Candidate.objects.create(
                    username=row[0],
                    city=row[1],
                    phone=row[2],
                    bachelor_school=row[3],
                    major=row[4],
                    degree=row[5],
                    test_score_of_general_ability=row[6],
                    paper_score=row[7]
                )

                print(candidate)
```

然后，在命令行中执行：
```bash
python manage.py import_candidates --path /path/to/your/file.csv
```

注意⚠️：csv文件中的信息和处理逻辑中的参数要对应起来。

## 后台动作

除过Django后台自带的行为，还可以自定义行为，然后注册在ModelAdmin中，即可方便快捷地完成某些任务。

先在定义一个函数，其中queryset是选择的model集合

```python
# 将候选人信息导出为CSV文件
def export_model_as_csv(modeladmin, request, queryset):
    response = HttpResponse(content_type='text/csv')
    field_list = f.exportable_fields
    response['Content-Disposition'] = 'attachment; filename=%s-list-%s.csv' % (
        'recruitment-candidates',
        datetime.now().strftime('%Y-%m-%d-%H-%M-%S'),
    )

    # 写入表头
    writer = csv.writer(response)
    writer.writerow(
        [queryset.model._meta.get_field(f).verbose_name.title() for f in field_list],
    )

    for obj in queryset:
        # 单行 的记录（各个字段的值）， 根据字段对象，从当前实例 (obj) 中获取字段值
        csv_line_values = []
        for field in field_list:
            field_object = queryset.model._meta.get_field(field)
            field_value = field_object.value_from_object(obj)
            csv_line_values.append(field_value)
        writer.writerow(csv_line_values)
    logger.info(" %s has exported %s candidate records" % (request.user.username, len(queryset)))

    return response


export_model_as_csv.short_description = u'导出为CSV文件'
```

然后在ModelAdmin中注册：

```python
class CandidateAdmin(admin.ModelAdmin):
    actions = (export_model_as_csv,)
    ...
    pass
```

# 中间件

Django提供了灵活易用的中间件机制，用函数或者类实现特定逻辑之后，加入settings中的MIDDLEWARE即可。可以看作Python中的装饰器。

## 函数实现

```python
# 以函数实现中间件
def performance_logger_middleware(get_response):
    def middleware(request):
        start_time = time.time()
        response = get_response(request)
        duration = time.time() - start_time
        response["X-Page-Duration-ms"] = int(duration * 1000)
        logger.info("%s %s %s", duration, request.path, request.GET.dict() )
        return response

    return middleware
```

## 类实现

```python
# 以类实现中间件，实现__call__方法
class PerformanceLoggerMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        start_time = time.time()
        response = self.get_response(request)
        duration = time.time() - start_time
        response["X-Page-Duration-ms"] = int(duration * 1000)
        logger.info("%s %s %s", duration, request.path, request.GET.dict())
        return response
```

然后将其注册在settings的MIDDLEWARE中。

```python
MIDDLEWARE = [
    'interview.performance.PerformanceLoggerMiddleware',  # or performance_logger_middleware
    ...
]
```

# Cache
## redis

首先，安装django-redis包，并在本地或者服务器上开启redis-server。

接着，在settings中配置缓存策略，如下：

```python
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            # "PASSWORD": "secret",
            "SOCKET_CONNECT_TIMEOUT": 5,  # seconds
            "SOCKET_TIMEOUT": 5,  # seconds
        }
    }
}
```

然后，加入缓存更新和获取的中间件：

```python
MIDDLEWARE = [
    ...
    'django.middleware.cache.UpdateCacheMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.cache.FetchFromCacheMiddleware',
    ...
]
```

OK