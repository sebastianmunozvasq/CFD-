import pandas as pd
import tkinter as tk
from tkinter import ttk, messagebox
import os
import threading


# Función para cargar inventario desde el archivo CSV
def cargar_inventario():
  global inventario 
  inventario = pd.read_csv(archivo_csv)

# Función para guardar inventario en el archivo CSV
def guardar_inventario():
  inventario.to_csv(archivo_csv, index=False, encoding='utf-8-sig')

# Función para mostrar inventario en la interfaz
def mostrar_inventario():
  global inventario
  tree_principal.delete(*tree_principal.get_children())
  for _, row in inventario.iterrows():
    tree_principal.insert("", "end", values=(row['Nombre'], row['Cantidad'], row['Precio'], row['Categoría'], row['Ventas']))

# Función para agregar productos
def agregar_producto():
  global inventario
  nombre = entry_nombre.get()
  cantidad = entry_cantidad.get()
  precio = entry_precio.get()
  categoria = combo_categoria.get()

  if not nombre or not cantidad:
    messagebox.showerror("Error", "Nombre y Cantidad son obligatorios")
    return
  #Validar cantidad ingresada
  try:
    cantidad = int(cantidad)
    if cantidad<0:
      raise ValueError("Error", "Cantidad debe ser un número positivo")
  except ValueError:
    messagebox.showerror("Error", "Cantidad debe ser un número positivo")
    return

  if nombre in inventario['Nombre'].values:
    # Si el producto ya existe, solo actualizamos la cantidad
    inventario.loc[inventario['Nombre'] == nombre, 'Cantidad'] += cantidad
    mostrar_inventario()
    messagebox.showinfo("Éxito", f"Producto existente actualizado: {cantidad} unidades añadidas a {nombre}")
  else:
    # Si el producto no existe
    if not precio or not categoria:
      messagebox.showerror("Error", "Los campos Precio y Categoría son obligatorios para nuevos productos")
      return
    #Validar precio de nuevo producto
    try:
      precio = float(precio)
      if precio < 0:
        raise ValueError("Error", "Precio debe ser un número positivo")
    except ValueError:
      messagebox.showerror("Error", "Precio debe ser un número positivo")
      return

    nuevo_item = pd.DataFrame({
          'Nombre': [nombre],
          'Cantidad': [cantidad],
          'Precio': [precio],
          'Categoría': [categoria],
          'Ventas': [0]})
    inventario = pd.concat([inventario, nuevo_item], ignore_index=True)
    mostrar_inventario()
    messagebox.showinfo("Éxito", "Producto nuevo agregado con éxito")
  
  # Guardar el inventario actualizado en el archivo CSV
  guardar_inventario()


# Función para quitar productos
def quitar_producto():
  global inventario
  nombre = entry_nombre.get()
  cantidad = entry_cantidad.get()

  if not nombre or not cantidad:
    messagebox.showerror("Error", "Debe completar los campos Nombre y Cantidad")
    return
  #Validar cantidad ingresada
  try:
    cantidad = int(cantidad)
    if cantidad<0:
      raise ValueError("Error", "Cantidad debe ser un número positivo")
    
  except ValueError:
    messagebox.showerror("Error", "Cantidad debe ser numérica")
    return

  if nombre in inventario['Nombre'].values:
    if inventario.loc[inventario['Nombre'] == nombre, 'Cantidad'].values[0] >= cantidad:
      inventario.loc[inventario['Nombre'] == nombre, 'Cantidad'] -= cantidad
      inventario.loc[inventario['Nombre'] == nombre, 'Ventas'] += cantidad
      mostrar_inventario()
      messagebox.showinfo("Éxito", f"Se quitaron {cantidad} unidades de {nombre}")
      
    else:
      messagebox.showerror("Error", "El stock disponible es menor que la cantidad a eliminar.")
      return
  else:
    messagebox.showerror("Error", "El producto no existe en el inventario")
    return
  # Guardar el inventario actualizado en el archivo CSV
  guardar_inventario()
  
#Buscar información de producto
def buscar_producto():
    global inventario
    nombre=entry_nombre.get()
    if not nombre:
        messagebox.showerror('Error', 'Debe ingresar nombre del producto')
        return
    else:    
        if nombre in inventario['Nombre'].values:
            cantidad=inventario.loc[inventario['Nombre']==nombre, 'Cantidad'].values[0]
            precio=inventario.loc[inventario['Nombre']==nombre, 'Precio'].values[0]
            categoria=inventario.loc[inventario['Nombre']==nombre, 'Categoría'].values[0]
            ventas=inventario.loc[inventario['Nombre']==nombre, 'Ventas'].values[0]
            messagebox.showinfo(f'{nombre}', f"El producto {nombre} se encuentra en el inventario. \nCantidad: {cantidad} \nPrecio: ${precio} \nCategoría: {categoria} \nVentas: {ventas}")  
        else:
            messagebox.showerror('Error', f'El producto {nombre} no se encuentra en inventario')

        
        
# Función para eliminar productos sin stock
def eliminar_sin_stock():
  global inventario
  if 0 in inventario['Cantidad'].values:
    inventario = inventario[inventario['Cantidad'] > 0]
    mostrar_inventario()
    messagebox.showinfo("Éxito", "Productos sin stock eliminados") 
  else:
    messagebox.showinfo("Información", "No hay productos sin stock")
    return
  # Guardar el inventario actualizado en el archivo CSV
  guardar_inventario()

# Función para advertir bajo stock manualmente
def advertencia_bajo_stock():
  global inventario
  prod_bajo_stock = inventario[inventario['Cantidad'] < 5]
  if prod_bajo_stock.empty:
    messagebox.showinfo("Información", "No hay productos con bajo stock")
  else:
    nombres = ", ".join(prod_bajo_stock['Nombre'].values)
    messagebox.showwarning("Advertencia", f"Productos con bajo stock: {nombres}")

# Función para advertir bajo stock periodicamente
def advertencia_bajo_stock_periodica():
    def ejecutar():
        advertencia_bajo_stock()
        # Se reprograma la siguiente ejecución en 1 hora (3600000 ms)
        ventana_principal.after(3600000, advertencia_bajo_stock_periodica)

    # Se ejecuta la función en un hilo separado para evitar bloqueo de la UI
    hilo_separado = threading.Thread(target=ejecutar)
    hilo_separado.daemon = True  # El hilo se cierra cuando la aplicación termina
    hilo_separado.start()
    

# Función para generar reportes
def generar_reporte():
  global inventario
  total_productos = inventario['Cantidad'].sum()
  mas_vendidos = inventario.sort_values(by='Ventas', ascending=False).head(5)
  menos_vendidos = inventario.sort_values(by='Ventas', ascending=True).head(5)
  menos_stock = inventario.sort_values(by='Cantidad', ascending=True).head(5)

  reporte_ventana = tk.Toplevel(ventana_principal)
  reporte_ventana.title("Reporte de Inventario")
  reporte_ventana.geometry("800x500")

  tree_reporte = ttk.Treeview(reporte_ventana, columns=("Nombre", "Cantidad", "Precio", "Categoría", "Ventas"), show="headings")
  tree_reporte.heading("Nombre", text="Nombre", anchor="center")
  tree_reporte.heading("Cantidad", text="Cantidad", anchor="center")
  tree_reporte.heading("Precio", text="Precio [$]", anchor="center")
  tree_reporte.heading("Categoría", text="Categoría", anchor="center")
  tree_reporte.heading("Ventas", text="Ventas", anchor="center")

  tree_reporte.column("Nombre", width=200, anchor="center")
  tree_reporte.column("Cantidad", width=100, anchor="center")
  tree_reporte.column("Precio", width=100, anchor="center")
  tree_reporte.column("Categoría", width=150, anchor="center")
  tree_reporte.column("Ventas", width=100, anchor="center")

  tree_reporte.pack(fill=tk.BOTH, expand=True, pady=10)

  reporte_data = []
  reporte_data.append(["Total de productos", total_productos, "", "", ""])
  reporte_data.append(["Productos más vendidos", "", "", "", ""])
  for _, row in mas_vendidos.iterrows():
    reporte_data.append([row['Nombre'], row['Cantidad'], row['Precio'], row['Categoría'], row['Ventas']])

  reporte_data.append(["Productos menos vendidos", "", "", "", ""])
  for _, row in menos_vendidos.iterrows():
    reporte_data.append([row['Nombre'], row['Cantidad'], row['Precio'], row['Categoría'], row['Ventas']])

  reporte_data.append(["Productos con menos stock", "", "", "", ""])
  for _, row in menos_stock.iterrows():
    reporte_data.append([row['Nombre'], row['Cantidad'], row['Precio'], row['Categoría'], row['Ventas']])

  for item in reporte_data:
    tree_reporte.insert("", "end", values=item)

# Ruta del archivo CSV
archivo_csv = "inventario.csv"
directorio = os.path.dirname(os.path.abspath(archivo_csv))
if os.path.exists(archivo_csv):
    print(f"El archivo '{archivo_csv}' se encuentra en la carpeta: {directorio}")
else:
    print(f"El archivo '{archivo_csv}' no se encuentra en la carpeta: {directorio}.")

# Cargar el inventario desde el archivo CSV
cargar_inventario()

# Crear ventana principal
ventana_principal = tk.Tk()
ventana_principal.title("Inventario Gifty")
ventana_principal.geometry("800x600")  # Agrandar la ventana

# Crear interfaz en la ventana principal
frame=tk.Frame(ventana_principal) #Crea el frame dentro de la ventana principal
frame.pack(pady=10) #Posiciona el frame dentro de la ventana principal

    #Etiquetas de entrada
tk.Label(frame, text='Nombre').grid(row=0, column=0, padx=5) 
tk.Label(frame, text='Cantidad').grid(row=1, column=0, padx=5)
tk.Label(frame, text='Precio [$]').grid(row=2, column=0, padx=5)
tk.Label(frame, text='Categoría').grid(row=3, column=0, padx=5)

    #Campos de entrada
entry_nombre=tk.Entry(frame) 
entry_nombre.grid(row= 0, column=1, padx=5)
entry_cantidad=tk.Entry(frame)
entry_cantidad.grid(row=1, column=1, padx=5)
entry_precio=tk.Entry(frame)
entry_precio.grid(row= 2, column=1, padx=5)
combo_categoria=ttk.Combobox(frame, values=['Papelería', 'Joyería', 'Juguetería', 'Electrónica', 'Hogar'], state='readonly')
combo_categoria.grid(row=3, column=1, padx=5)


    #Botones interactivos
boton_agregar = tk.Button(frame, text="Agregar Producto", command=agregar_producto)
boton_agregar.grid(row=4, column=0, pady=10)
boton_quitar = tk.Button(frame, text="Quitar Producto", command=quitar_producto)
boton_quitar.grid(row=4, column=1, pady=10)
boton_buscar = tk.Button(ventana_principal, text='Buscar Producto', command=buscar_producto)
boton_buscar.pack(pady=5)
boton_eliminar_stock0 = tk.Button(ventana_principal, text="Eliminar Productos sin Stock", command=eliminar_sin_stock)
boton_eliminar_stock0.pack(pady=5)
boton_bajo_stock = tk.Button(ventana_principal, text="Comprobar Bajo Stock", command=advertencia_bajo_stock)
boton_bajo_stock.pack(pady=5)
boton_reporte = tk.Button(ventana_principal, text="Generar Reporte", command=generar_reporte)
boton_reporte.pack(pady=5)

    #Crear tabla para mostrar el inventario en ventana principal
tree_principal = ttk.Treeview(ventana_principal, columns=("Nombre", "Cantidad", "Precio", "Categoría", "Ventas"), show="headings")
        #Crear columnas
tree_principal.heading("Nombre", text="Nombre", anchor="center")
tree_principal.heading("Cantidad", text="Cantidad", anchor="center")
tree_principal.heading("Precio", text="Precio [$]", anchor="center")
tree_principal.heading("Categoría", text="Categoría", anchor="center")
tree_principal.heading("Ventas", text="Ventas", anchor="center")
    
        #Configurar datos en las columnas
tree_principal.column("Nombre", width=200, anchor="center")
tree_principal.column("Cantidad", width=100, anchor="center")
tree_principal.column("Precio", width=100, anchor="center")
tree_principal.column("Categoría", width=150, anchor="center")
tree_principal.column("Ventas", width=100, anchor="center")

tree_principal.pack(fill=tk.BOTH, expand=True, pady=10)


# Mostrar inventario al inicio del loop
mostrar_inventario()

# Ejecutar la primera advertencia periódica de bajo stock
advertencia_bajo_stock_periodica()

# Iniciar la aplicación
ventana_principal.mainloop()
