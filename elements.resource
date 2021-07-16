*** Variables ***
&{myip}     ipv4=id:ipv4
&{clash}    menu=//header/div/div
...         btn_login=//div[contains(@class,'login-menu')]/a[contains(@href,'login')]
...         form_login=//div[contains(@class,'login-form-container')]
...         menu_account=//div[contains(@class,'login-menu')]/div/button 
...         dropdown_menu_account=//button[@data-reactid='.0.2.0.0.0.0.2.0.0.0']
...         my_account=//a[@data-reactid='.0.2.0.0.0.0.2.0.0.1.0.0']
...         btn_create_new_key=//a[@data-reactid='.0.2.0.1.1.0.0.1.1.0']
...         list_keys=//ul[@class='api-keys']
...         item_key=//li[@class='api-key']
...         last_key_name=//li[@class='api-key'][last()]//h4[@class='api-key__name']
...         api_token=//samp[@data-reactid='.0.2.0.1.0.0.0.1.0.0.1.0']
...         back_to_mykeys=//a[@data-reactid='.0.2.0.1.0.0.0.0.2']
...         logout=//a[@data-reactid='.0.2.0.0.0.0.2.0.0.1.2.0']
...         cookie_consent=//div[@class='cc-compliance']/a[contains(@class,'cc-btn')]