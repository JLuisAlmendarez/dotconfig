# Lista de meses
meses=(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)

# Colores
bg_cpu="#6897bb"
fg_cpu="#0c2a44"
bg_ram="#5f9ea0"
fg_ram="#0d2e2f"
bg_gpu="#800000"
fg_gpu="#f0d9d9"
bg_fecha="#6a8759"
fg_fecha="#142310"


# CPU
cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{printf "%.0f%%", 100 - $8}')

# RAM
ram=$(free -g | awk '/Mem/{printf "%dGB/%dGB", $3, $2}')

# GPU (VRAM)
gpu_raw=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
if [ -n "$gpu_raw" ]; then
	gpu_used_mb=$(echo "$gpu_raw" | cut -d',' -f1 | tr -d ' ')
	gpu_total_mb=$(echo "$gpu_raw" | cut -d',' -f2 | tr -d ' ')
	gpu_used_gb=$(awk "BEGIN {printf \"%.1f\", $gpu_used_mb/1024}")
	gpu_total_gb=$(awk "BEGIN {printf \"%.1f\", $gpu_total_mb/1024}")
	gpu="${gpu_used_gb}GB/${gpu_total_gb}GB"
else
	gpu="N/A"
fi

# Fecha
dia=$(date +%d)
mes_numero=$(date +%m | sed 's/^0//')
mes_nombre=${meses[$((mes_numero - 1))]}
anio=$(date +%Y)
hora=$(date +%H:%M)
fecha="${dia} de ${mes_nombre} del ${anio}, Hora: ${hora}"

# Forma
sep="#[bg=${bg_sep},fg=${fg_sep}] "

echo "#[bg=${bg_cpu},fg=${fg_cpu}] CPU ${cpu} ${sep}#[bg=${bg_ram},fg=${fg_ram}] RAM ${ram} ${sep}#[bg=${bg_gpu},fg=${fg_gpu}] GPU ${gpu} ${sep}#[bg=${bg_fecha},fg=${fg_fecha}] ${fecha} "
