import tkinter as tk
from tkinter import ttk, messagebox
from pynput.mouse import Listener, Controller, Button
from pynput import keyboard
import threading
import time

class AutoClickerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("AutoClicker")
        self.mouse = Controller()
        self.recorded_actions = []
        self.is_recording = self.is_playing = False
        self.click_delay = 0.1
        self.loop_count = 1
        self.loop_infinite = False
        self.hotkey = '<f9>'  # Default hotkey as a string with angle brackets

        self.create_widgets()
        self.start_hotkey_listener()

    def create_widgets(self):
        button_frame = ttk.Frame(self.root)
        button_frame.pack(pady=10, fill=tk.X)

        for text, command in [("บันทึก", self.start_recording),
                              ("หยุดบันทึก", self.stop_recording),
                              ("เล่นซ้ำ", self.start_playing),
                              ("หยุดเล่น", self.stop_playing)]:
            ttk.Button(button_frame, text=text, command=command).pack(side=tk.LEFT, expand=True)

        self.status_label = ttk.Label(self.root, text="สถานะ: รอการสั่งการ")
        self.status_label.pack(pady=10)

        self.recorded_text = tk.Text(self.root, height=10, width=50, font=("Arial", 10))
        self.recorded_text.pack(pady=10, fill=tk.BOTH, expand=True)

        ttk.Label(self.root, text="ปรับความเร็วในการคลิก:").pack(pady=10)
        self.speed_scale = tk.Scale(self.root, from_=1, to=100, orient=tk.HORIZONTAL, command=self.update_click_delay)
        self.speed_scale.set(10)
        self.speed_scale.pack(pady=10, fill=tk.X)

        ttk.Label(self.root, text="จำนวนรอบในการเล่นซ้ำ:").pack(pady=10)
        self.loop_count_entry = ttk.Entry(self.root)
        self.loop_count_entry.insert(0, "1")
        self.loop_count_entry.pack(pady=10)

        self.loop_infinite_var = tk.BooleanVar()
        ttk.Checkbutton(self.root, text="วนลูปตลอด", variable=self.loop_infinite_var).pack(pady=10)

        self.hotkey_label = ttk.Label(self.root, text=f"Hotkey ปัจจุบัน: {self.hotkey}")
        self.hotkey_label.pack(pady=10)

        # Hotkey changing section
        ttk.Label(self.root, text="เปลี่ยนคีย์ลัด:").pack(pady=10)
        self.selected_hotkey_label = ttk.Label(self.root, text="คุณเลือก: None")
        self.selected_hotkey_label.pack(pady=10)
        self.root.bind("<Key>", self.set_new_hotkey)

        ttk.Button(self.root, text="ตกลง", command=self.confirm_hotkey).pack(pady=10)

    def update_click_delay(self, value):
        self.click_delay = 1 / (int(value) / 10)

    def start_hotkey_listener(self):
        threading.Thread(target=self.listen_for_hotkeys, daemon=True).start()

    def listen_for_hotkeys(self):
        def on_activate():
            if self.is_playing:
                self.stop_playing()
            else:
                self.start_playing()
        # Use string representation for the hotkey with angle brackets
        with keyboard.GlobalHotKeys({self.hotkey: on_activate}) as listener:
            listener.join()

    def start_recording(self):
        self.recorded_actions.clear()
        self.is_recording = True
        self.status_label.config(text="สถานะ: กำลังบันทึก...")
        self.recorded_text.delete(1.0, tk.END)
        threading.Thread(target=self.record_mouse_and_keyboard_actions).start()

    def stop_recording(self):
        self.is_recording = False
        self.status_label.config(text="สถานะ: หยุดบันทึก")

    def record_mouse_and_keyboard_actions(self):
        with Listener(on_click=self.on_click) as mouse_listener, keyboard.Listener(on_press=self.on_key_press) as keyboard_listener:
            mouse_listener.join()
            keyboard_listener.join()

    def on_click(self, x, y, button, pressed):
        if pressed and self.is_recording:
            self.recorded_actions.append(('click', (x, y, button)))
            self.recorded_text.insert(tk.END, f"Recorded {button} click at ({x}, {y})\n")
            self.recorded_text.see(tk.END)

    def on_key_press(self, key):
        if self.is_recording:
            key_name = key.char if hasattr(key, 'char') else str(key)
            self.recorded_actions.append(('key', key))
            self.recorded_text.insert(tk.END, f"Recorded key press: {key_name}\n")
            self.recorded_text.see(tk.END)

    def start_playing(self):
        if not self.recorded_actions:
            self.status_label.config(text="สถานะ: ไม่มีการบันทึก")
            return
        self.is_playing = True
        self.status_label.config(text="สถานะ: กำลังเล่นซ้ำ...")
        self.loop_count = int(self.loop_count_entry.get()) if self.loop_count_entry.get().isdigit() else 1
        self.loop_infinite = self.loop_infinite_var.get()
        threading.Thread(target=self.play_recorded_actions).start()

    def stop_playing(self):
        self.is_playing = False
        self.status_label.config(text="สถานะ: หยุดเล่น")

    def play_recorded_actions(self):
        for _ in range(float('inf') if self.loop_infinite else self.loop_count):
            if not self.is_playing:
                break
            for action in self.recorded_actions:
                if not self.is_playing:
                    break
                if action[0] == 'click':
                    x, y, button = action[1]
                    self.mouse.position = (x, y)
                    self.mouse.click(button)
                elif action[0] == 'key':
                    key = action[1]
                    keyboard.Controller().press(key)
                    keyboard.Controller().release(key)
                time.sleep(self.click_delay)

    def set_new_hotkey(self, event):
        modifiers = []
        if event.state & 0x0004:  # Ctrl
            modifiers.append("Ctrl")
        if event.state & 0x0001:  # Shift
            modifiers.append("Shift")
        hotkey_combination = "+".join(modifiers + [event.keysym])
        self.selected_hotkey_label.config(text=f"คุณเลือก: {hotkey_combination}")

    def confirm_hotkey(self):
        new_hotkey = self.selected_hotkey_label.cget("text").replace("คุณเลือก: ", "")
        if new_hotkey == "None":
            messagebox.showwarning("Warning", "กรุณาเลือกคีย์ลัดก่อน!")
            return
        self.hotkey = f'<{new_hotkey.lower()}>'  # Store hotkey with angle brackets
        self.hotkey_label.config(text=f"Hotkey ปัจจุบัน: {new_hotkey}")

if __name__ == "__main__":
    root = tk.Tk()
    app = AutoClickerApp(root)
    root.mainloop()
