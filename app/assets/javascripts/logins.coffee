# 入力情報を保持
@inputString = (id) ->
  document.getElementById("disp").value += "●"
  document.getElementById("pass").value += id + ","
  document.getElementById("disp").focus()

# パスをリセット
@resetPass = ->
  document.getElementById("pass").value = ""
