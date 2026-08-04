FROM python:3.10-slim

# C, Flex এবং Bison ইনস্টল করার কমান্ড
RUN apt-get update && apt-get install -y flex bison make gcc

WORKDIR /app

# প্রজেক্টের সব ফাইল সার্ভারে কপি করবে
COPY . /app

# ফ্লাস্ক ইনস্টল করবে
RUN pip install flask

EXPOSE 8080

# ওয়েবসাইট রান করবে
CMD ["python", "app.py"]