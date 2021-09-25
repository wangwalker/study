# Django常用包

## 样式
### 主题
#### grappelli

安装方式：
```s
pip install django-grappelli
```

使用方式：
```python
# 加入INSTALLED_APPS，settings
INSTALLED_APPS = [
    'grappelli',
    ...
]

# 添加URL，urls
urlpatterns = [
    path('admin/', admin.site.urls),
    path(r"grappelli", include("grappelli.urls")),
]
```

#### simpleui

simpleui是element-ui+vue开发的，界面看起来更加现代化一点。

安装方式：
```s
pip install django-simpleui
```

加入INSTALLED_APPS，即可完成。
```python
# 加入INSTALLED_APPS，settings
INSTALLED_APPS = [
    'grappelli',
    ...
]
```

详细介绍：[Simple UI官方文档](https://simpleui.72wo.com/docs/simpleui/#%E5%AE%98%E7%BD%91)

### CSS样式
#### bootstrap4

使用bootstrap适配表单样式。

安装：
```s
pip install django-bootstrap4
```

加入INSTALLED_APPS，即可完成。
```python
# 加入INSTALLED_APPS，settings
INSTALLED_APPS = [
    'bootstrap4',
    ...
]
```

在html文件头加入：

```html
{# Load the tag library #}
{% load bootstrap4 %}

{# Load CSS and JavaScript #}
{% bootstrap_css %}
{% bootstrap_javascript jquery='full' %}

{# Display django.contrib.messages as Bootstrap alerts #}
{% bootstrap_messages %}
```

## 通知
### 钉钉聊天机器人

首先，安装DingtalkChatbot包。

接着，在钉钉群的【智能助手】中添加自定义聊天机器人，可以通过关键字、SecretKey或IP地址创建Web Hook地址，然后保存在Django配置文件settings中。

```python
DINGTALK_WEB_HOOK = 'https://oapi.dingtalk.com/robot/send?access_token=******'
```

然后，实现发送消息的具体逻辑，比如在tingtalk中定义：

```python
from dingtalkchatbot.chatbot import DingtalkChatbot
from django.conf import settings

def send(message, at_mobiles=[]):
    # 引用 settings里面配置的钉钉群消息通知的WebHook地址:
    webhook = settings.DINGTALK_WEB_HOOK

    # 初始化机器人小丁, # 方式一：通常初始化方式
    ding = DingtalkChatbot(webhook)

    # 方式二：勾选“加签”选项时使用（v1.5以上新功能）
    # xiaoding = DingtalkChatbot(webhook, secret=secret)

    # Text消息@所有人，这里是通过关键字【通知】创建的，at_mobiles为信息接受者注册钉钉的手机号
    ding.send_text(msg=('通知: %s' % message), at_mobiles=['15091850645'])
```

最后，在具体的业务逻辑中调用`dingtalk.send("some_message")`即可。

