#!/usr/bin/env python3
import psutil
import datetime
from flask import Flask, render_template

app = Flask(__name__)

def get_system_info():
    """Get real-time system information"""
    boot_time = datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")
    
    # CPU usage
    cpu_percent = psutil.cpu_percent(interval=1)
    cpu_count = psutil.cpu_count()
    
    # Memory usage
    memory = psutil.virtual_memory()
    memory_percent = memory.percent
    memory_total = round(memory.total / (1024**3), 2)  # GB
    memory_used = round(memory.used / (1024**3), 2)    # GB
    memory_available = round(memory.available / (1024**3), 2)  # GB
    
    # Disk usage
    disk = psutil.disk_usage('/')
    disk_percent = (disk.used / disk.total) * 100
    disk_total = round(disk.total / (1024**3), 2)  # GB
    disk_used = round(disk.used / (1024**3), 2)    # GB
    disk_free = round(disk.free / (1024**3), 2)     # GB
    
    return {
        'boot_time': boot_time,
        'cpu_percent': cpu_percent,
        'cpu_count': cpu_count,
        'memory_percent': memory_percent,
        'memory_total': memory_total,
        'memory_used': memory_used,
        'memory_available': memory_available,
        'disk_percent': disk_percent,
        'disk_total': disk_total,
        'disk_used': disk_used,
        'disk_free': disk_free
    }

@app.route('/')
def dashboard():
    """Main dashboard page"""
    system_info = get_system_info()
    return render_template('dashboard.html', system_info=system_info)

@app.route('/api/system')
def api_system():
    """API endpoint for system information"""
    return get_system_info()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
