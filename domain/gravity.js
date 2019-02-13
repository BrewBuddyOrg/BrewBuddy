'use strict';

class Gravity {
    /**
     * @param {number} plato
     */
    constructor(plato) {
        this._plato = plato;
    }

    /**
     * @returns {number}
     */
    getSG() {
        if (this._plato < 259) {
            return 259 / (259 - this._plato);
        }
        return 1;
    }

    /**
     * @returns {number}
     */
    getPlato() {
        return this._plato;
    }

    /**
     * @returns {Gravity}
     */
    static createFromSG(sg) {
       if (sg > 0.5) {
           return new Gravity(259 - 259 / sg);
       }
       return new Gravity(0);
    }

    /**
     * @returns {Gravity}
     */
    static createFromPlato(plato) {
        return new Gravity(plato);
    }
}

module.exports = Gravity;
