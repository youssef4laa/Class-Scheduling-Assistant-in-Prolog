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
