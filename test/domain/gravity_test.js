'use strict';

const assert = require('assert');
const Gravity = require('../../domain/gravity');

describe('Domain.Gravity', () => {
    
    const assertFloatMatchesWithPrecision = (actual, expected, precision) => {
        assert(Math.abs(expected - actual) <= precision, `expected ${expected} but received ${actual}`);
    };

    it('should be able to create a gravity with a plato value', () => {
        const gravity = Gravity.createFromPlato(12.4);
        assert.strictEqual(gravity.getPlato(), 12.4);
        assertFloatMatchesWithPrecision(gravity.getSG(), 1.05028, 0.001);
    });

    it('should be able to create a gravity with an sg value', () => {
        const gravity = Gravity.createFromSG(1.05);
        assertFloatMatchesWithPrecision(gravity.getPlato(), 12.4, 0.1);
        assertFloatMatchesWithPrecision(gravity.getSG(), 1.05, 0.001);
    })
});