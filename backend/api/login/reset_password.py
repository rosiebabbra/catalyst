from firebase_admin import auth


email = 'user@example.com'
action_code_settings = auth.ActionCodeSettings(
    url='https://www.example.com/checkout?cartId=1234',
    handle_code_in_app=True,
    ios_bundle_id='com.example.ios',
    android_package_name='com.example.android',
    android_install_app=True,
    android_minimum_version='12',
    dynamic_link_domain='coolapp.page.link',
)
reset_link = auth.generate_password_reset_link(email, action_code_settings)


import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Email configuration
sender_email = "rosiebabbra@gmail.com"
sender_password = "your_password"
recipient_email = "rosiebabbra@example.com"
subject = "Password Reset"
message_body = "Click the link below to reset your password."

# Create the email message
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = recipient_email
message["Subject"] = subject

message.attach(MIMEText(message_body, "plain"))
message.attach(MIMEText(f'<a href="{reset_link}">Reset Password</a>', "html"))

# Connect to the SMTP server and send the email
try:
    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(sender_email, sender_password)
    server.sendmail(sender_email, recipient_email, message.as_string())
    server.quit()
    print("Email sent successfully")
except Exception as e:
    print(f"Email sending failed: {str(e)}")
