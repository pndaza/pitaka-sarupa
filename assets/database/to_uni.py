import sqlite3
import Rabbit

db_file = 'pitaka_sarupa.db'

conn = sqlite3.connect(db_file)
cursor = conn.cursor()
cursor.execute('select * from sarupa_zg')
rows = cursor.fetchall()
for row in rows:
    id = row[0]
    enum = Rabbit.zg2uni(row[1])
    content = Rabbit.zg2uni(row[3])
    ref = Rabbit.zg2uni(row[4])

    cursor.execute('insert into topic values (?,?,?,?)', (id, enum, content, ref))

conn.commit()
conn.close()


