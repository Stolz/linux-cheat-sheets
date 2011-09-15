# How to download from Megaupload Premium account using the command line

## All in one

	wget -c --post-data "login=MU_USERNAME&password=MU_PASSWORD" MU_LINK

## Alternative

	wget --save-cookies cookiemegaupload --post-data="username=MU_USERNAME&password=MU_PASSWORD&login=1" "http://www.megaupload.com/?c=login"
	wget --load-cookies=cookiemegaupload MU_LINK