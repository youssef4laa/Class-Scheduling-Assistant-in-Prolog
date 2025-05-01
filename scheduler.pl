:- consult('studentKB').
:- set_prolog_flag(answer_write_options, [max_depth(0)]). %prevents the ... in Prolog
university_schedule(Schedule) :- %part a
    findall(Student, studies(Student, _), UnsortedStudents),
    sort(UnsortedStudents, SortedStudents),
    helper_university_schedule(SortedStudents, Schedule).

helper_university_schedule([], []).
helper_university_schedule([Student|RestOfStudents],
                           [sched(Student, Slots)|RestOfSchedules]) :-
    student_schedule(Student, Slots),  
    no_clashes(Slots),                        
    study_days(Slots, 5),
    helper_university_schedule(RestOfStudents, RestOfSchedules).
student_schedule(Student_id, Schedule) :- %part b
    findall(Course, studies(Student_id, Course), Courses),
    sort(Courses, SortedCourses),
    find_course_slots(SortedCourses, CourseSlots),
    generate_schedules(CourseSlots, Schedule).

find_course_slots([], []).
find_course_slots([Course | Courses], [Slots | OtherSlots]) :-
    findall(slot(Day, SlotNum, Course), course_scheduled(Course, Day, SlotNum), Slots),
    Slots \= [],
    find_course_slots(Courses, OtherSlots).

course_scheduled(Course, Day, SlotNum) :-
    day_schedule(Day, SlotsList),
    nth1(SlotNum, SlotsList, Slot),
    member(Course, Slot).

generate_schedules([], []).
generate_schedules([Slots|Rest], [Slot|Schedule]) :-
    member(Slot, Slots),
    generate_schedules(Rest, Schedule).

no_clashes([]). %part c
no_clashes([slot(Day, SlotNum, _) | Rest]) :-
    \+ (member(slot(Day, SlotNum, _), Rest)),
    no_clashes(Rest).

    count_study_days(Schedule, Count) :-
        maplist(extract_day, Schedule, Days),
        sort(Days, UniqueDays),
        length(UniqueDays, Count).
    extract_day(slot(Day, _, _), Day).
    
    study_days(Slots, DayCount) :- %part d
        maplist(extract_day, Slots, Days),    
        sort(Days, UniqueDays),               
        length(UniqueDays, Count),         
        Count =< DayCount.
    

assembly_hours(Schedules, AH) :- %part e
    findall(slot(Day, SlotNum),
            ( member(sched(_, Slots), Schedules),
              member(slot(Day, SlotNum, _), Slots)
            ),
            OccupiedSlots),
    list_to_set(OccupiedSlots, UniqueOccupiedSlots),
    common_study_days(Schedules, UnsortedCommonDays),
    sort(UnsortedCommonDays, CommonDays),
    findall(slot(Day, SlotNum),
            ( member(Day, CommonDays),
              between(1, 5, SlotNum),
              \+ member(slot(Day, SlotNum), UniqueOccupiedSlots)
            ),
            AH).


common_study_days([], []).
common_study_days([sched(_, Schedule)], Days) :-
    findall(Day, member(slot(Day, _, _), Schedule), DayList),
    list_to_set(DayList, Days).
common_study_days([sched(_, Schedule)|Rest], CommonDays) :-
    findall(Day, member(slot(Day, _, _), Schedule), DayList),
    list_to_set(DayList, Days),
    common_study_days(Rest, RestOfCommon),
    intersect(Days, RestOfCommon, CommonDays).

intersect([], _, []).
intersect([H|T], L, [H|Res]) :-
    member(H, L),
    intersect(T, L, Res).
intersect([H|T], L, Res) :-
    \+ member(H, L),
    intersect(T, L, Res).
