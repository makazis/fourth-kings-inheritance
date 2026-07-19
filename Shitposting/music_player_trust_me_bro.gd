extends Node2D

var links={
	"https://youtu.be/kClwJxgmrgk?si=GxCWQNQ2wpQkzaGW":Vector3(0,3,38),	
	"https://youtu.be/j8_c5FwGuDs?si=BWCn-JHWKEZ0Ep4l":Vector3(0,21,23),
	"https://youtu.be/hWTFG3J1CP8?si=7b-KhF1jDevH1HVS":Vector3(0,6,47),
	"https://youtu.be/KM7z4qWoJdU?si=v_Jj2BMTnk67Ss0Y":Vector3(0,3,50),
	"https://youtu.be/IQ3W9ELXuV4?si=2DF41CyNXaQIlQi1":Vector3(0,2,43),
	"https://youtu.be/J6eJgl46S1s":Vector3(0,2,29),
	"https://www.youtube.com/watch?v=fj8FLZp39ao":Vector3(0,5,4),
	"https://youtu.be/eVr3qNDnrYs?si=5qvXmoao0LxFvlq4":Vector3(0,3,18),
	"https://youtu.be/f_0ssea3iTI?si=eodGbxj7AEKfLyRd":Vector3(0,1,29),
	"https://youtu.be/MByMCC57E3g":Vector3(0,4,37),
	"https://youtu.be/iNGClJV92h8?si=EDmpUzdyIPSq6QrL":Vector3(0,2,10),
	"https://youtu.be/x1-uhEf7xCk?si=WwvRlmiryBtfzEvK":Vector3(0,3,1),
	"https://youtu.be/0JvRHZVTLyI?si=SGfvuiBYMjqGCytN":Vector3(0,1,15),
	"https://youtu.be/1yMozrDEqbg?si=tBxLiP1NSDszL7UO":Vector3(0,4,16),
	"https://youtu.be/uGTHlijjuZw?si=1QvHnjnuJHKHTll9":Vector3(0,5,23),
	"https://youtu.be/VO2Eh_h7lCw?si=eNsEJQ6HGpy_-QAy":Vector3(0,1,2),
	"https://youtu.be/F4QBFIdKwoE?si=1zKu0hFCwub0Moag":Vector3(0,0,12),
	"https://youtu.be/Kbryz0mxuMY?si=A_dauszwRX6kNDTb":Vector3(0,4,35),
	"https://youtu.be/owTPZQQAVyQ?si=8DtCoQ0TY0T2I2qU":Vector3(0,3,9),
	"https://youtu.be/hh49C_OcsCQ?si=LzfQQZM-rL2dqvh2":Vector3(0,5,3),
	"https://youtu.be/aR0jF_tEPXg?si=jCSS_SS7UK5blrnT":Vector3(0,2,22),
	"https://youtu.be/yLHCm7e0uBg?si=i7amiIynytYyCOeG":Vector3(0,2,0),
	"https://youtu.be/6G1Acl_pqYw?si=gbwVxl0HYHiUTERJ":Vector3(0,6,0),
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var random_link=links.keys().pick_random()
	OS.shell_open(random_link)
	if randi_range(0,19)==0:
		_on_timer_timeout()
	else:	
		$Timer.start(links[random_link][0]*3600+links[random_link][1]*60+links[random_link][2]+3)
