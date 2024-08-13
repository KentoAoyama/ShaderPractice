using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleMoveObject : MonoBehaviour
{
    [SerializeField]
    private float _moveDistance = 10.0f;

    [SerializeField]
    private float _moveSpeed = 1.0f;

    private float _timer = 0f;
    private Vector3 _defaultPos;

    private void Start()
    {
        _defaultPos = transform.position;
    }

    private void Update()
    {
        _timer += Time.deltaTime * _moveSpeed;
        float moveValue = _moveDistance * Mathf.Sin(_timer);
        Vector3 currentPos = new(
            _defaultPos.x,
            _defaultPos.y,
            _defaultPos.z + moveValue);

        transform.position = currentPos;
    }
}
