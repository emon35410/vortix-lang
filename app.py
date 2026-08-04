from flask import Flask, render_template, request
import subprocess
import os

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    output = ""
    code = ""
    if request.method == 'POST':
        code = request.form['code']
        
        # ইউজার ওয়েবে যা লিখবে, তা একটি টেম্পোরারি ফাইলে সেভ হবে
        with open("web_demo.vtx", "w") as f:
            f.write(code)

        try:
            # প্রথমে C কোড কম্পাইল করবে
            subprocess.run(["make"], capture_output=True)
            # এরপর Vortix কোডটি রান করবে
            result = subprocess.run(["./vortix", "web_demo.vtx"], capture_output=True, text=True, timeout=5)
            
            output = result.stdout
            if result.stderr:
                output += "\nError: " + result.stderr
        except Exception as e:
            output = f"Execution Error: {str(e)}"

    return render_template('index.html', code=code, output=output)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)