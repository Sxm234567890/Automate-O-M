import json
num_200=0
num_403=0
other_status=0
with open('access_json.log','r',encoding='utf-8') as file:
       for line in file.readlines():
             json_line=json.load(line)
             if json_line.get("status")=="200":
                  num_200+=1
             elif json_line.get("status")=="403":
                  num_403+=1
             else:
                 other_status+=1
print("客户成功访问次数:",num_200)
print("返回状态码403次数:",num_403)
       
